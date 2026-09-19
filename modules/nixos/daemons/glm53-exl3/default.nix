# GLM-5.3-Flash EXL3 on a 2× DGX Spark (GB10 / SM121) — vLLM TP=2 over CX7.
#
# Member units poll for the weight fetch (glm53-exl3-download) and then run
# the MiaAI-Lab overlay image:
#   head   (lain)  : rank 0 + OpenAI API on :${port}
#   worker (arisu) : rank 1, --headless
#
# Weights land in ${hfHome}/hub/models--<org>--<name> (standard HF hub cache
# layout — the launchers resolve snapshots via refs/main with a
# latest-snapshot fallback). Both nodes fetch independently; no cross-node
# rsync.
#
# Fabric pins (enp1s0f0np0 / mlx5_0) match the cabled socket-A pair from
# tix.dgx-interconnect. Serve args mirror upstream start.sh defaults:
#   https://github.com/MiaAI-Lab/GLM-5.3-Flash-EXL3-2x-DGX-Sparks
#
# State as of upstream ~1.6.0+ (pin eb0469f→ca85576 era, 2026-09-02..21):
#   image :exl3-instanttensor (InstantTensor 0.2.0 loader + E2/E3 fat kernels
#   baked; GHCR build 2026-09-16). Context 850k / util 0.85 / MNBT 7168 per
#   upstream (E3's ~560 MiB fat-row scratch charges the KV budget — 1M no
#   longer fits a full-length request on this kit). Mixed prefill = fair v5
#   (replaces "skip"). APC no-store + indexer rightsize now defaults.
#   Post-health boot-shape warmup runs as the glm53-exl3-warmup oneshot
#   (upstream GLM53_BOOT_SHAPE_WARMUP=1 default; replaces the old skip).
#   DFlash2 drafter pinned to upstream revision dc77ff1c.
#
# Runtime-applied patches (mounted from the pinned glm53-flash input, run
# before `vllm serve`) mirror upstream start.sh's GLM53_OVERLAY_ORDER:
#   video_placeholders → suppress_stops → scheduler_decode_floor (fair v5) →
#   glm5_drafter_group (DFlash2 KV page-share) → hybrid_prefix_hit →
#   apc_per_group_retention → apc_no_store → kv_capacity_log →
#   tool_choice_none → xgrammar_termination → kpool_tail_slotmap → spinwait →
#   adaptive_k → dense_fp8 (inert: GLM53_DENSE_FP8 off) →
#   default_max_new_tokens → indexer_workspace → cache_reset → ablit.
#   overlay/exl3.py is mounted directly over the image's copy, immune to
#   image rebuild lag.
#   DFlash2 drafter shards across TP (draft_tensor_parallel_size=2).
#   ABLIT refusal-ablation is implemented via the upstream transplant recipe
#   (byte-exact donor o_proj L15-45) — gated by the ablitEnabled flag below;
#   artifacts persist in /var/lib/glm53-ablit. Set ablitEnabled=false for
#   stock o_proj (hook stays installed but is inert unless ABLIT=1).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.services.glm53-exl3;

  dlEnv = pkgs.python3.withPackages (ps: [ ps.huggingface-hub ]);

  modelId = "Mia-AiLab/GLM-5.3-Flash-EXL3-TR3-4bpw";
  modelRevision = "25a44fdbf16862a46b7cc9921142c6c81350af2f";
  modelCacheName = "models--Mia-AiLab--GLM-5.3-Flash-EXL3-TR3-4bpw";
  dflashId = "incoai/GLM-5.3-Flash-DFlash2";
  dflashCacheName = "models--incoai--GLM-5.3-Flash-DFlash2";
  # upstream pins the drafter revision (1.4.0-era .env.example)
  dflashRevision = "dc77ff1c99eeb2df044ee3d4f0094eb033fee410";
  image = "ghcr.io/miaai-lab/glm-5.3-flash-2x-dgx-sparks:exl3-instanttensor";

  # ABLIT — opt-in refusal-direction ablation (upstream "dealign-oproj-
  # transplant", 6d75590). true = at weight-load, o_proj L15-45 (+ the
  # checkpoint MTP block) is replaced with the donor's abliterated tensors;
  # the ~2.7 GiB transplant is fetched once into /var/lib/glm53-ablit
  # (resumable, sha-verified) and the direction files ride in from the
  # glm53-flash input. false = stock o_proj (hook inert without ABLIT=1).
  # Flip requires a switch on BOTH hosts (artifacts fetched per node).
  ablitEnabled = true;
  ablitDir = "/var/lib/glm53-ablit";

  # upstream excludes non-weight repo dirs from the big pull
  dlExcludes = lib.concatStringsSep " " (
    map (p: "--exclude '${p}'") [
      "runtime-results/**"
      "src/**"
      "runtime/src/**"
      "scripts/**"
      "docs/**"
      "results/**"
      ".materialization/**"
      "runtime/scripts/**"
    ]
  );

  containerEnv = {
    # CX7 fabric pins — cabled socket A on both hosts (see tix.dgx-interconnect).
    # Without these: Gloo binds a loopback alias (rank peer connect refused),
    # NCCL picks arbitrary interfaces, and ncclCommInitRank hangs.
    NCCL_SOCKET_IFNAME = "enp1s0f0np0";
    GLOO_SOCKET_IFNAME = "enp1s0f0np0";
    NCCL_IB_HCA = "mlx5_0";
    NCCL_IB_DISABLE = "0";
    NCCL_IB_ROCE_VERSION_NUM = "2";
    NCCL_IB_GID_INDEX = "3";
    NCCL_NET = "IB";
    NCCL_NET_PLUGIN = "none";
    NCCL_NVLS_ENABLE = "0";
    NCCL_CUMEM_ENABLE = "0";
    NCCL_IB_MERGE_NICS = "0";
    NCCL_CROSS_NIC = "0";
    NCCL_IGNORE_CPU_AFFINITY = "1";
    NCCL_DEBUG = "WARN";
    NCCL_DEBUG_SUBSYS = "INIT,NET";
    HF_HUB_OFFLINE = "1";
    TRANSFORMERS_OFFLINE = "1";
    HF_HOME = "/root/.cache/huggingface";
    VLLM_CACHE_ROOT = "/root/.cache/vllm";
    GLM53_SUPPRESS_STOPS_IN_REASONING = "1";
    # Mixed-step prefill policy: upstream TP2 default is now fair-share v5
    # (service-time share, largest step-fitting chunk, decode first) — the
    # old "skip" default was replaced in 1.4.0 (#186/#188/#194).
    GLM53_MIXED_PREFILL_CHUNK = "fair";
    GLM53_FAIR_PREFILL_CHUNK = "256";
    GLM53_FAIR_PREFILL_SHARE = "0.30";
    GLM53_FAIR_PREFILL_MAX_INTERVAL_MS = "2000";
    GLM53_FAIR_PREFILL_MAX_STEP_MS = "2000";
    GLM53_FAIR_PREFILL_MAX_CHUNKS = "1";
    # E2 direct fat-expert kernel + E3 grouped fat-expert MoE (upstream
    # 1.2.0 defaults). Require the instanttensor image (exl3_fat_gemm /
    # exl3_fat_moe extensions baked in). E3 = +37-45% cold prefill.
    EXL3_FAT_KERNEL = "1";
    EXL3_FAT_GROUPED = "1";
    # E3 row width (upstream: 32 with E3, 256 with E2; 128 was the E1 value)
    EXL3_TEMP_ROWS_FUSED = "32";
    EXL3_FUSED_MOE = "1";
    DFLASH_TOKENS = "7";
    # SpinCondition reader busy-loop window (upstream c190db1, PR #96).
    # Stock = vLLM's 1 s default; upstream's frozen sweep picked 16 ms.
    GLM53_SPINWAIT_MS = "16";
    # DFlash skipped-window KV block logging (upstream #94)
    GLM53_KV_CAPACITY_LOG = "1";
    # APC no-store gate (upstream 1.4.0 default on, #95)
    GLM53_APC_NO_STORE = "1";
    # Sparse-indexer shared-memory right-sizing (upstream 1.2.0 default)
    GLM53_INDEXER_WORKSPACE = "rightsize";
    # Omitted-only default max_new_tokens (legacy completion default 16
    # covered; explicit limits still win — upstream #51)
    DEFAULT_MAX_NEW_TOKENS = "65536";
    TRITON_CACHE_DIR = "/root/.triton/cache";
    TILELANG_CACHE_DIR = "/root/.tilelang/cache";
    VLLM_EXECUTE_MODEL_TIMEOUT_SECONDS = "1800";
    TORCH_CUDA_ARCH_LIST = "12.1a";
    FLASHINFER_CUDA_ARCH_LIST = "12.1a";
    FLASHINFER_DISABLE_VERSION_CHECK = "1";
    PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True";
    VLLM_ENGINE_READY_TIMEOUT_S = "3600";
    VLLM_NO_USAGE_STATS = "1";
    DO_NOT_TRACK = "1";
  } // lib.optionalAttrs ablitEnabled {
    # Load-time refusal-direction ablation. METHOD=transplant is explicit on
    # purpose: missing artifacts must fail loudly, never silently fall back
    # to the proj path (upstream measured it as statistically random vs
    # stock o_proj — i.e. quality garbage).
    ABLIT = "1";
    ABLIT_METHOD = "transplant";
    ABLIT_DIRECTION = "dealign";
    ABLIT_LAYERS = "15-45";
    ABLIT_INCLUDE_MTP = "1";
  };

  envFlags = lib.concatStringsSep " \\\n  " (
    lib.mapAttrsToList (k: v: "-e ${k}=${v}") containerEnv
  );

  # resolve-snapshot CACHE_DIR PROBE_FILE — prints the snapshot commit hash
  # whose dir contains PROBE_FILE; prefers refs/main, falls back to latest.
  resolveScript = pkgs.writeShellScript "glm53-exl3-resolve-snapshot" ''
    d="$1"
    probe="$2"
    h="$(cat "$d/refs/main" 2>/dev/null || true)"
    if [ -n "$h" ] && [ -f "$d/snapshots/$h/$probe" ]; then
      printf '%s' "$h"
      exit 0
    fi
    h="$(ls -1t "$d/snapshots" 2>/dev/null | head -n 1)"
    if [ -n "$h" ] && [ -f "$d/snapshots/$h/$probe" ]; then
      printf '%s' "$h"
      exit 0
    fi
    exit 1
  '';

  mkMember =
    role:
    let
      isHead = role == "head";
      selfIP = if isHead then cfg.headIP else cfg.workerIP;
      nodeRank = if isHead then 0 else 1;
      containerName = "glm53-exl3-${role}";

      memberArgs =
        [
          "--served-model-name"
          "GLM-5.3-Flash-EXL3"
          "--host"
          "0.0.0.0"
          "--port"
          (toString cfg.port)
          "--tensor-parallel-size"
          "2"
          "--nnodes"
          "2"
          "--node-rank"
          (toString nodeRank)
          "--master-addr"
          cfg.headIP
          "--master-port"
          (toString cfg.masterPort)
          "--distributed-executor-backend"
          "mp"
          "--tool-call-parser"
          "glm47"
          "--enable-auto-tool-choice"
          "--reasoning-parser"
          "glm45"
          "--enable-prefix-caching"
          "--no-enable-flashinfer-autotune"
          "--quantization"
          "exl3"
          "--max-model-len"
          # upstream 1.2.0+: 850k — E3's ~560 MiB fat-row scratch charges the
          # KV budget, so 1M / util 0.87 no longer fits one full-length req.
          "850000"
          "--gpu-memory-utilization"
          # 2026-09-20: rendezvous finally completes and both ranks load, but
          # v0.21+ CUDA-graph memory profiling reserves ~1.5 GiB up front, and
          # the KV check hard-fails: 850k needs 13.46 GiB, 0.85 only leaves
          # 10.27 GiB (est. max len 397824). 0.87 (upstream's 1M util) reaches
          # only ~12.7; 0.88 reaches ~13.9 — clears 13.46 with ~0.4 GiB slack.
          # The old 0.88 NVRM-OOM risk is mitigated by the upfront graph
          # reservation + breakable cudagraph (bounded 1..64 capture sizes).
          "0.88"
          "--max-num-seqs"
          "4"
          "--max-num-batched-tokens"
          # upstream E2/E3 keep 7168 (2026-09-01 one-shot; 100k ~1148 tok/s).
          # Requires the instanttensor image (exl3_fat_gemm ext) — do NOT
          # raise without it (3584+ regressed on the legacy tier).
          "7168"
          "--kv-cache-dtype"
          "fp8"
          "--load-format"
          # InstantTensor 0.2.0 fast weight loader (baked into the image)
          "instanttensor"
          "--speculative-config"
          "$SPEC_CONFIG"
          "--chat-template"
          "/opt/glm53/chat_template.jinja"
          "--limit-mm-per-prompt"
          # image cap 4 → 48 upstream (#146/#183), bounded by the per-image
          # token cap below so a chat video cannot OOM the host
          ''{"image":48,"video":1}''
          "--mm-processor-kwargs"
          ''{"max_image_tokens":2048}''
          "--mm-processor-cache-gb"
          "1"
          "--skip-mm-profiling"
        ]
        ++ lib.optionals (!isHead) [ "--headless" ];

      # each array element single-quoted (args contain no single quotes)
      argsArray = ''
        args=(
          "$MODEL_DIR"
          ${lib.concatStringsSep "\n          " (map (a: if a == "$SPEC_CONFIG" then "\"$SPEC_CONFIG\"" else "'${a}'") memberArgs)}
        )
      '';
    in
    {
      description = "GLM-5.3-Flash EXL3 rank ${toString nodeRank} (${role})";
      # NOTE: deliberately NOT After=glm53-exl3-download.service — for a
      # Type=oneshot that means "wait for full completion" (hours on first
      # boot). The wait-for-weights loop lives in the ExecStart script
      # instead, so the unit goes active(running) immediately.
      # Workers additionally gate on glm53-exl3-wait-head (below): the
      # head's rank-0 opens its rendezvous store ~2-4 min into ITS boot,
      # and a worker that starts too early latches its store client onto
      # a dead store instance forever (the 2026-09-19 deadlock).
      after =
        [ "network-online.target" ]
        ++ lib.optionals (!isHead) [ "glm53-exl3-wait-head.service" ];
      wants =
        [ "network-online.target" ]
        ++ lib.optionals (!isHead) [ "glm53-exl3-wait-head.service" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        # crash-loops (container exit) must never be rate-limited while it
        # waits for the peer rank or pulls the overlay image
        StartLimitIntervalSec = 0;
      };

      serviceConfig = {
        ExecStartPre = [
          "-${pkgs.podman}/bin/podman rm -f ${containerName}"
          # GB10 unified memory: drop page cache accumulated by weight
          # download/rsync so the KV-memory probe and CUDA allocations see
          # the full pool. Cache only — regenerates on demand.
          "-${pkgs.bash}/bin/sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'"
        ];
        ExecStart = pkgs.writeShellScript "glm53-exl3-${role}-start" ''
          set -euo pipefail

          # pull the overlay image (swallow failure; podman run auto-pulls)
          "${pkgs.podman}/bin/podman" pull ${image} || true

          ${lib.optionalString ablitEnabled ''
            # ABLIT artifacts: mirror the input's ablit/ dir into persistent
            # storage, then fetch the donor o_proj transplant (range-requested
            # ~2.7 GiB, resumable, sha-verified — instant once populated).
            # Failure must not take the whole serve down on a flaky HF day;
            # the runtime's METHOD=transplant check is the loud gate.
            mkdir -p ${ablitDir}/ablit/transplant
            cp -u ${inputs.glm53-flash}/ablit/LAYER_MAP.json \
                  ${inputs.glm53-flash}/ablit/refusal_direction_glm53_dealign_late.pt \
                  ${inputs.glm53-flash}/ablit/refusal_direction_glm53_bf_oproj.pt \
                  ${inputs.glm53-flash}/ablit/fetch_transplant.py \
                  ${ablitDir}/ablit/
            ${pkgs.python3}/bin/python3 ${ablitDir}/ablit/fetch_transplant.py \
              || echo "ABLIT: donor fetch failed this round (resumes next start)"
          ''}

          # wait for weights — lives in the long-lived process, so the unit
          # is active(running) at once and never blocks the start job (which
          # would wedge multi-user.target and the switch activation).
          while :; do
            ok=1
            "${resolveScript}" "${cfg.hfHome}/hub/${modelCacheName}" config.json >/dev/null || ok=0
            "${resolveScript}" "${cfg.hfHome}/hub/${dflashCacheName}" model.safetensors >/dev/null || ok=0
            [ "$ok" = 1 ] && break
            echo "weights pending; retrying in 30s..."
            sleep 30
          done
          echo "weights ready"

          # second drop right before CUDA allocations begin — covers the
          # page cache re-grown by a rsync/download that finished after
          # this unit started (worker waits for sync, then launches).
          sync; echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true

          mHash="$(${resolveScript} "${cfg.hfHome}/hub/${modelCacheName}" config.json)"
          dHash="$(${resolveScript} "${cfg.hfHome}/hub/${dflashCacheName}" model.safetensors)"
          MODEL_DIR="/root/.cache/huggingface/hub/${modelCacheName}/snapshots/$mHash"
          DFLASH_MODEL_DIR="/root/.cache/huggingface/hub/${dflashCacheName}/snapshots/$dHash"

          # draft_tensor_parallel_size=2: shard the ~2.3 GiB DFlash2 drafter
          # across TP (upstream d29de5d default, measured keep on 2× GB10).
          # 1 would keep it on rank 0 only (no CX7 per draft step).
          SPEC_CONFIG="$(
            "${pkgs.python3}/bin/python3" -c 'import json,sys
print(json.dumps({"method":"dflash","model":sys.argv[1],"num_speculative_tokens":7,"kv_cache_dtype":"auto","draft_sample_method":"probabilistic","rejection_sample_method":"standard","draft_tensor_parallel_size":2}))' \
              "$DFLASH_MODEL_DIR"
          )"

          echo "launching ${role} rank ${toString nodeRank}: model=$MODEL_DIR"

          ${argsArray}

          # NOTE: patch_dense_fp8 is deliberately NOT in the patch chain —
          # it anchors on the image-baked exl3.py, and our runtime-mounted
          # (newer) overlay rev makes it SystemExit mid-chain, killing the
          # whole serve. Only needed for the opt-in GLM53_DENSE_FP8 feature
          # (off here). Re-add if that feature is ever enabled.

          exec ${pkgs.podman}/bin/podman run --rm --name ${containerName} \
            --network host --ipc=host --stop-timeout 60 \
            --device nvidia.com/gpu=all \
            --device /dev/infiniband \
            --cap-add IPC_LOCK \
            --ulimit memlock=-1 --ulimit stack=67108864 \
            --security-opt label=disable \
            -v ${cfg.hfHome}:/root/.cache/huggingface \
            -v /var/lib/vllm-glm53-flash:/root/.cache/vllm \
            -v /var/lib/vllm-glm53-flash/triton:/root/.triton/cache \
            -v /var/lib/vllm-glm53-flash/tilelang:/root/.tilelang/cache \
            -v ${inputs.glm53-flash}/files/chat_template.jinja:/opt/glm53/chat_template.jinja:ro \
            -v ${inputs.glm53-flash}/overlay/patch_glm_video_placeholders.py:/opt/glm53/patch_glm_video_placeholders.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_suppress_stops_in_reasoning.py:/opt/glm53/patch_suppress_stops_in_reasoning.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_scheduler_decode_floor.py:/opt/glm53/patch_scheduler_decode_floor.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_glm5_drafter_group.py:/opt/glm53/patch_glm5_drafter_group.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_hybrid_prefix_hit.py:/opt/glm53/patch_hybrid_prefix_hit.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_xgrammar_termination.py:/opt/glm53/patch_xgrammar_termination.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_kpool_tail_slotmap.py:/opt/glm53/patch_kpool_tail_slotmap.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_spinwait.py:/opt/glm53/patch_spinwait.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_apc_per_group_retention.py:/opt/glm53/patch_apc_per_group_retention.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_apc_no_store.py:/opt/glm53/patch_apc_no_store.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_kv_capacity_log.py:/opt/glm53/patch_kv_capacity_log.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_tool_choice_none.py:/opt/glm53/patch_tool_choice_none.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_adaptive_k.py:/opt/glm53/patch_adaptive_k.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_default_max_new_tokens.py:/opt/glm53/patch_default_max_new_tokens.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_indexer_workspace.py:/opt/glm53/patch_indexer_workspace.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_cache_reset.py:/opt/glm53/patch_cache_reset.py:ro \
            -v ${inputs.glm53-flash}/overlay/exl3.py:/usr/local/lib/python3.12/dist-packages/vllm/model_executor/layers/quantization/exl3.py:ro \
            -v ${inputs.glm53-flash}/overlay/patch_ablit.py:/opt/glm53/patch_ablit.py:ro \
            -v ${inputs.glm53-flash}/overlay/ablit_runtime.py:/opt/glm53/ablit_runtime.py:ro \
            -v ${ablitDir}/ablit:/opt/glm53/ablit:ro \
            ${envFlags} \
            -e MODEL_DIR="$MODEL_DIR" \
            -e DFLASH_MODEL_DIR="$DFLASH_MODEL_DIR" \
            -e VLLM_HOST_IP=${selfIP} \
            --entrypoint bash ${image} \
            -c 'python3 /opt/glm53/patch_glm_video_placeholders.py && python3 /opt/glm53/patch_suppress_stops_in_reasoning.py && python3 /opt/glm53/patch_scheduler_decode_floor.py && python3 /opt/glm53/patch_glm5_drafter_group.py && python3 /opt/glm53/patch_hybrid_prefix_hit.py && python3 /opt/glm53/patch_apc_per_group_retention.py && python3 /opt/glm53/patch_apc_no_store.py && python3 /opt/glm53/patch_kv_capacity_log.py && python3 /opt/glm53/patch_tool_choice_none.py && python3 /opt/glm53/patch_xgrammar_termination.py && python3 /opt/glm53/patch_kpool_tail_slotmap.py && python3 /opt/glm53/patch_spinwait.py && python3 /opt/glm53/patch_adaptive_k.py && python3 /opt/glm53/patch_default_max_new_tokens.py && python3 /opt/glm53/patch_indexer_workspace.py && python3 /opt/glm53/patch_cache_reset.py && python3 /opt/glm53/patch_ablit.py && exec vllm serve "$@"' vllm \
            "''${args[@]}"
        '';
        ExecStop = "-${pkgs.podman}/bin/podman stop -t 60 ${containerName}";
        TimeoutStopSec = "70";
        TimeoutStartSec = "0";
        Restart = "always";
        # NOTE: on-failure is NOT enough — a dead EngineCore makes vLLM shut
        # the API server down and podman exits 0, which reads as "success"
        # and left the cluster silently dead overnight (2026-08-29). Any
        # exit must restart; only a systemd stop may keep it down.
        RestartSec = "15s";
      };
    };
in
{
  options.services.glm53-exl3 = {
    enable = lib.mkEnableOption ''
      the GLM-5.3-Flash EXL3 cluster member (vLLM TP=2 across two DGX Sparks
      over the CX7 fabric). Weights auto-fetch into /var/lib/models/hf
      (standard hub cache layout).
    '';

    role = lib.mkOption {
      type = lib.types.enum [
        "head"
        "worker"
      ];
      description = ''
        head = rank 0 + OpenAI API (this is lain); worker = rank 1 --headless
        (arisu).
      '';
    };

    headIP = lib.mkOption {
      type = lib.types.str;
      default = "192.168.100.10";
    };

    workerIP = lib.mkOption {
      type = lib.types.str;
      default = "192.168.100.11";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
    };

    masterPort = lib.mkOption {
      type = lib.types.port;
      default = 29521;
    };

    hfHome = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/models/hf";
      description = ''
        HF cache root; weights land in <hfHome>/hub/models--<org>--<name>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      dlEnv
      pkgs.rsync
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/models 0755 root root - -"
      "d /var/lib/models/hf 0755 taki users - -"
      "d /var/lib/models/hf/hub 0755 taki users - -"
      "d /var/lib/vllm-glm53-flash 0755 root root - -"
      "d /var/lib/vllm-glm53-flash/triton 0755 root root - -"
      "d /var/lib/vllm-glm53-flash/tilelang 0755 root root - -"
      "d /var/lib/glm53-ablit 0755 root root - -"
      # podman stages image pulls in /var/tmp (own subvol, survives reboots);
      # failed/interrupted pulls leak ~10G staging dirs. Saw 210G pile up on
      # lain from setup-night pulls (2026-08). Age out anything older than a day.
      "e /var/tmp/container_images_storage* - - - 1d"
    ];

    # Only the head (lain) fetches from HF. The worker gets weights via
    # glm53-exl3-sync (head pulls once, rsyncs over the CX7 fabric — no
    # duplicate download / bandwidth on arisu).
    systemd.services.glm53-exl3-download = lib.mkIf (cfg.role == "head") {
      description = "GLM-5.3-Flash EXL3 + DFlash2 weight fetch into ${cfg.hfHome}";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      # critical: without HF_HOME, hf download writes to ~/.cache/huggingface
      environment.HF_HOME = cfg.hfHome;

      serviceConfig = {
        Type = "oneshot";
        User = "taki";
        Group = "users";
        UMask = "0022";
        RemainAfterExit = true;
        TimeoutStartSec = "0";
        ExecStart = pkgs.writeShellScript "glm53-exl3-download" ''
          set -euo pipefail

          hfBin="${dlEnv}/bin/hf"
          [ -x "$hfBin" ] || hfBin="${dlEnv}/bin/huggingface-cli"

          echo "fetching ${modelId} (revision ${modelRevision}) ..."
          "$hfBin" download "${modelId}" --revision "${modelRevision}" ${dlExcludes}

          echo "fetching ${dflashId} (revision ${dflashRevision}) ..."
          "$hfBin" download "${dflashId}" --revision "${dflashRevision}"

          # hf download can leave refs/main empty; member units also fall
          # back to latest snapshot on their own, this keeps the cache
          # self-consistent.
          for d in "${cfg.hfHome}/hub/${modelCacheName}" "${cfg.hfHome}/hub/${dflashCacheName}"; do
            mkdir -p "$d/refs"
            if [ ! -s "$d/refs/main" ]; then
              printf '%s' "$(ls -1t "$d/snapshots" 2>/dev/null | head -n 1)" > "$d/refs/main"
            fi
          done

          shards="$(find "${cfg.hfHome}/hub/${modelCacheName}/snapshots" -name '*.safetensors' 2>/dev/null | wc -l)"
          echo "EXL3 shards present: $shards/120"
        '';
      };
    };

    # Head pulls from HF once, then rsyncs the world to the worker over the
    # CX7 fabric (192.168.100.11). Worker's hub dir is taki-owned (tmpfiles);
    # rsync as taki writes through. After=download so it only runs post-fetch.
    systemd.services.glm53-exl3-sync = lib.mkIf (cfg.role == "head") {
      description = "Sync GLM-5.3-Flash EXL3 weights to the worker over CX7";
      after = [ "glm53-exl3-download.service" ];
      wants = [ "glm53-exl3-download.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "taki";
        Group = "users";
        RemainAfterExit = true;
        TimeoutStartSec = "0";
        ExecStart = pkgs.writeShellScript "glm53-exl3-sync" ''
          set -euo pipefail

          echo "syncing ${modelCacheName} to worker ..."
          "${pkgs.rsync}/bin/rsync" -a --partial -e "${pkgs.openssh}/bin/ssh" --rsync-path=/run/current-system/sw/bin/rsync \
            "${cfg.hfHome}/hub/${modelCacheName}/" \
            "taki@${cfg.workerIP}:${cfg.hfHome}/hub/${modelCacheName}/"

          echo "syncing ${dflashCacheName} to worker ..."
          "${pkgs.rsync}/bin/rsync" -a --partial -e "${pkgs.openssh}/bin/ssh" --rsync-path=/run/current-system/sw/bin/rsync \
            "${cfg.hfHome}/hub/${dflashCacheName}/" \
            "taki@${cfg.workerIP}:${cfg.hfHome}/hub/${dflashCacheName}/"

          echo "worker sync complete"
        '';
      };
    };

    # Worker gate: block the worker unit until the head's rendezvous port
    # (TCPStore) is accepting connections. Fails loudly (exit 1) after
    # ~45 min so the worker's Restart=always keeps cycling.
    #
    # 2026-09-19 post-mortem of the "root-in-unit /dev/tcp silently fails"
    # saga (400+ missed polls, then 10 min of missed live store windows
    # even after switching the gate to User=taki): NOT a network, cgroup,
    # or user-context problem at all. Systemd unit contexts run with a
    # minimal PATH, and this unit's PATH had no bash directory. The poll
    # `timeout 2 bash -c "</dev/tcp/…"` resolved `timeout` (coreutils) but
    # the inner `bash` failed PATH lookup → exit 127 on every single poll,
    # hidden by 2>/dev/null. Fix: absolute store paths for every binary,
    # so PATH resolution can never matter again.
    #
    # RemainAfterExit keeps the unit "active (exited)" after success so
    # later switches/worker restarts don't re-run the poll and block
    # multi-user.target (which made `nh os switch` hang for many minutes).
    systemd.services.glm53-exl3-wait-head = lib.mkIf (cfg.role == "worker") {
      description = "Wait for the GLM-5.3 head rendezvous port";
      before = [ "glm53-exl3-worker.service" ];
      wantedBy = [ "glm53-exl3-worker.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "taki";
        TimeoutStartSec = "50min";
        ExecStart = pkgs.writeShellScript "glm53-exl3-wait-head" ''
          for i in $(seq 1 540); do
            if ${pkgs.coreutils}/bin/timeout 2 ${pkgs.bash}/bin/bash -c "</dev/tcp/${cfg.headIP}/${toString cfg.masterPort}" 2>/dev/null; then
              echo "head rendezvous port is open (after ~$((i * 5))s)"
              exit 0
            fi
            ${pkgs.coreutils}/bin/sleep 5
          done
          echo "head rendezvous port never opened within 45min"; exit 1
        '';
      };
    };

    # Post-health DFlash2/sampler/kpool shape warmup (upstream
    # GLM53_BOOT_SHAPE_WARMUP=1 default, scripts/boot-shape-warmup.sh).
    # Their start.sh runs it host-side after /health; ours is a oneshot that
    # waits for health, then burns the uncovered shapes once per image.
    # Non-fatal: uncovered shapes JIT mid-serve instead.
    systemd.services.glm53-exl3-warmup = lib.mkIf (cfg.role == "head") {
      description = "GLM-5.3-Flash EXL3 post-health boot shape warmup";
      after = [ "glm53-exl3-head.service" ];
      wants = [ "glm53-exl3-head.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = "45min";
        ExecStart = pkgs.writeShellScript "glm53-exl3-warmup" ''
          set -uo pipefail
          PATH="${pkgs.curl}/bin:${pkgs.bash}/bin:$PATH"

          # wait for /health (boot takes ~25-40 min; JIT caches may rebuild)
          for i in $(seq 1 120); do
            code=$(curl -s -m 3 -o /dev/null -w "%{http_code}" http://127.0.0.1:${toString cfg.port}/health 2>/dev/null || true)
            [ "$code" = "200" ] && break
            sleep 30
          done
          [ "$code" = "200" ] || { echo "warmup: head never went healthy"; exit 0; }

          GLM53_WARMUP_MAX_CONCURRENCY=4 \
          GLM53_WARMUP_REQ_TIMEOUT=240 \
          GLM53_WARMUP_DFLASH_K=7 \
          GLM53_WARMUP_TRITON_CACHE_DIR=/var/lib/vllm-glm53-flash/triton \
            bash ${inputs.glm53-flash}/scripts/boot-shape-warmup.sh \
              http://127.0.0.1:${toString cfg.port} GLM-5.3-Flash-EXL3 \
            || echo "warmup: incomplete — uncovered shapes may JIT mid-serve"
        '';
      };
    };

    systemd.services."glm53-exl3-${cfg.role}" = mkMember cfg.role;
  };
}
