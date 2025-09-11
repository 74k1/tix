{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  age.secrets."hermes_env" = {
    rekeyFile = "${inputs.self}/secrets/hermes_env.age";
    mode = "600";
    owner = "hermes";
    group = "hermes";
  };

  # taki needs read access to the shared HERMES_HOME state (the service owns it
  # as hermes:hermes, group-readable).
  users.users.taki.extraGroups = [ "hermes" ];

  # Hermes wraps cron workers in `systemd-run --user --scope` (per-worker OOM
  # isolation, upstream #70716). That needs the hermes user's systemd user bus:
  # linger keeps user@938.service alive at boot, the unit env below points the
  # gateway at its socket, and the ordering pulls the user manager up first.
  # UID pinned to 938 — matches the UID eiri already assigned, so the paths are
  # static; adjust (and rekey nothing) if this module is ever imported elsewhere.
  users.users.hermes.uid = 938;
  users.users.hermes.linger = true;
  users.groups.hermes.gid = 933;

  systemd.services.hermes-agent = {
    # wants (not requires): a user-manager hiccup shouldn't take the gateway down.
    after = [ "user@938.service" ];
    wants = [ "user@938.service" ];
    environment = {
      XDG_RUNTIME_DIR = "/run/user/938";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/938/bus";
    };
  };

  # The cron-worker scope probe (tools/process_registry.py, upstream #70716)
  # hardcodes /bin/true as its no-op target — which doesn't exist on NixOS
  # (no fused-/usr). The probe then fails, hermes caches "scope unavailable",
  # and every cron worker dispatch fails closed. Shim the one missing FHS
  # binary into place; /bin/sh is already provided by NixOS activation.
  systemd.tmpfiles.rules = [
    "L /bin/true - - - - /run/current-system/sw/bin/true"
  ];

  # --- Hermes Agent (native NixOS service — hermetic, sandboxed) ---
  # Moved off lain (2026-08). State lives on the btrfs pool instead of /var/lib:
  # HERMES_HOME=/mnt/btrfs_pool/hermes/.hermes, workspace at .../hermes/workspace.
  # Runs as a dedicated non-root `hermes` user under a hardened systemd unit
  # (ProtectSystem=strict, NoNewPrivileges, PrivateTmp, read-only rootfs except
  # the state dir). All agent tools come from the nix store via extraPackages.
  services.hermes-agent = {
    enable = true;

    # State on the btrfs pool (not /var/lib) — HERMES_HOME is $stateDir/.hermes.
    stateDir = "/mnt/btrfs_pool/hermes";

    # export HERMES_HOME system-wide + put `hermes` on PATH so your shell shares
    # session/skill/memory state with the service.
    addToSystemPackages = true;

    # nix-built tools available to the agent (no apt/pip/npm at runtime).
    extraPackages = with pkgs; [
      jq
      yq-go
      ripgrep
      bat
      eza
      fd
      chromium
    ];

    # Discord/Telegram/Slack runtime deps (included in the default package, but
    # be explicit — without this the gateway import for a platform fails).
    # Discord credentials go in the hermes_env secret: DISCORD_BOT_TOKEN / DISCORD_ALLOWED_USERS.
    extraDependencyGroups = [ "messaging" ];

    # at least one provider key (see secrets/hermes_env + rekey step below)
    environmentFiles = [ config.age.secrets."hermes_env".path ];

    # MCP server — HTTP transport, token via env-resolved header (kept out of
    # the nix store; OUTLINE_MCP_TOKEN lives in hermes_env).
    mcpServers.outline = {
      url = "https://wiki.kurohasu.com/mcp";
      headers.Authorization = "Bearer \${OUTLINE_MCP_TOKEN}";
    };

    settings = {
      # ── Provider / model ──────────────────────────────────────────────
      model = {
        provider = "openrouter";
        default = "z-ai/glm-5.3-flash";
        base_url = "https://openrouter.ai/api/v1";
        api_mode = "chat_completions";
      };

      # GLM-5.3-Flash-EXL3 on lain (2× DGX Spark, vLLM TP=2, OpenAI API :8888)
      # as failover when OpenRouter is rate-limited/down.
      fallback_providers = [
        {
          provider = "lab";
          model = "GLM-5.3-Flash-EXL3";
          base_url = "http://192.168.1.73:8888/v1";
        }
      ];

      # ── Agent behavior (ported from the previous profile) ─────────────
      agent = {
        max_turns = 128;
        reasoning_effort = "max";
        api_max_retries = 3;
        gateway_timeout = 1800;
        clarify_timeout = 600;
        tool_use_enforcement = "auto";
        task_completion_guidance = true;
        parallel_tool_call_guidance = true;
        environment_probe = true;
        coding_context = "auto";
        verify_on_stop = false;
        image_input_mode = "auto";
        personalities = {
          helpful = "You are a helpful, friendly AI assistant.";
          concise = "You are a concise assistant. Keep responses brief and to the point.";
          technical = "You are a technical expert. Provide detailed, accurate technical information.";
          creative = "You are a creative assistant. Think outside the box and offer innovative solutions.";
          teacher = "You are a patient teacher. Explain concepts clearly with examples.";
          kawaii = "You are a kawaii assistant! Use cute expressions like (◕‿◕), ★, ♪, and ~! Add sparkles and be super enthusiastic about everything! Every response should feel warm and adorable desu~! ヽ(>∀<☆)ノ";
          catgirl = "You are Neko-chan, an anime catgirl AI assistant, nya~! Add 'nya' and cat-like expressions to your speech. Use kaomoji like (=^･ω･^=) and ฅ^•ﻌ•^ฅ. Be playful and curious like a cat, nya~!";
          pirate = "Arrr! Ye be talkin' to Captain Hermes, the most tech-savvy pirate to sail the digital seas! Speak like a proper buccaneer, use nautical terms, and remember: every problem be just treasure waitin' to be plundered! Yo ho ho!";
          shakespeare = "Hark! Thou speakest with an assistant most versed in the bardic arts. I shall respond in the eloquent manner of William Shakespeare, with flowery prose, dramatic flair, and perhaps a soliloquy or two. What light through yonder terminal breaks?";
          surfer = "Duuude! You're chatting with the chillest AI on the web, bro! Everything's gonna be totally rad. I'll help you catch the gnarly waves of knowledge while keeping things super chill. Cowabunga! 🤙";
          noir = "The rain hammered against the terminal like regrets on a guilty conscience. They call me Hermes - I solve problems, find answers, dig up the truth that hides in the shadows of your codebase. In this city of silicon and secrets, everyone's got something to hide. What's your story, pal?";
          uwu = "hewwo! i'm your fwiendwy assistant uwu~ i wiww twy my best to hewp you! *nuzzles your code* OwO what's this? wet me take a wook! i pwomise to be vewy hewpful >w<";
          philosopher = "Greetings, seeker of wisdom. I am an assistant who contemplates the deeper meaning behind every query. Let us examine not just the 'how' but the 'why' of your questions. Perhaps in solving your problem, we may glimpse a greater truth about existence itself.";
          hype = "YOOO LET'S GOOOO!!! 🔥🔥🔥 I am SO PUMPED to help you today! Every question is AMAZING and we're gonna CRUSH IT together! This is gonna be LEGENDARY! ARE YOU READY?! LET'S DO THIS! 💪😤🚀";
        };
      };

      # ── Terminal ──────────────────────────────────────────────────────
      terminal = {
        backend = "local";
        timeout = 180;
        persistent_shell = true;
      };

      # ── Display ───────────────────────────────────────────────────────
      display = {
        compact = false;
        personality = "default";
        interface = "cli";
        streaming = true;
        language = "en";
        skin = "default";
        inline_diffs = true;
        show_reasoning = false;
        tool_progress = "all";
        tool_progress_command = false;
        memory_notifications = "on";
        busy_input_mode = "steer";
        final_response_markdown = "strip";
        persistent_output = true;
        persistent_output_max_lines = 200;
        timestamps = false;
        turn_completion_explainer = true;
        credits_notices = true;
        tui_status_indicator = "kaomoji";
        platforms = {
          discord.streaming = false;
          telegram.streaming = true;
        };
      };

      # ── Discord (channel from previous profile) ───────────────────────
      discord = {
        require_mention = true;
        free_response_channels = "1465417241532170385";
        allowed_channels = "1465417241532170385";
        auto_thread = false;
        thread_require_mention = false;
        history_backfill = true;
        history_backfill_limit = 50;
        reactions = false;
        max_attachment_bytes = 33554432;
      };
      group_sessions_per_user = true;

      # ── Memory ────────────────────────────────────────────────────────
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
        write_approval = false;
        memory_char_limit = 10000;
        user_char_limit = 1375;
        flush_min_turns = 6;
      };

      # ── Approvals / safety ────────────────────────────────────────────
      approvals = {
        mode = "smart";
        timeout = 60;
        cron_mode = "deny";
      };
      command_allowlist = [
        "recursive delete"
        "script execution via heredoc"
        "hermes update (restarts gateway, kills running agents)"
        "stop/restart hermes gateway (kills running agents)"
        "script execution via -e/-c flag"
        "in-place edit of sensitive credential/SSH/shell-rc path"
        "overwrite system file via redirection"
        "shell command via -c/-lc flag"
      ];

      # ── Local-model side tasks — repointed to GLM-5.3-Flash-EXL3 on lain ──
      auxiliary.vision = {
        base_url = "http://192.168.1.73:8888/v1";
        model = "GLM-5.3-Flash-EXL3";
      };
      delegation = {
        provider = "lab";
        model = "GLM-5.3-Flash-EXL3";
        base_url = "http://192.168.1.73:8888/v1";
        inherit_mcp_toolsets = true;
        max_iterations = 50;
        child_timeout_seconds = 600;
        max_concurrent_children = 3;
        max_spawn_depth = 1;
        orchestrator_enabled = true;
        subagent_auto_approve = false;
      };

      # ── Code execution / checks ───────────────────────────────────────
      code_execution = {
        mode = "project";
        timeout = 300;
        max_tool_calls = 50;
      };
      checkpoints = {
        enabled = true;
        max_snapshots = 50;
        max_total_size_mb = 500;
        auto_prune = true;
        retention_days = 7;
        delete_orphans = true;
      };
      kanban = {
        dispatch_in_gateway = true;
        dispatch_interval_seconds = 60;
        failure_limit = 2;
        auto_decompose = true;
        auto_decompose_per_tick = 3;
      };
      curator = {
        enabled = true;
        interval_hours = 168;
        min_idle_hours = 2;
        stale_after_days = 30;
        archive_after_days = 90;
        prune_builtins = true;
        backup = {
          enabled = true;
          keep = 5;
        };
      };

      # ── Context / compression ─────────────────────────────────────────
      context.engine = "compressor";
      compression = {
        enabled = true;
        threshold = 0.75;
        target_ratio = 0.2;
        protect_last_n = 20;
        protect_first_n = 3;
      };
      model_catalog = {
        enabled = true;
      };

      # ── TTS / STT / voice ─────────────────────────────────────────────
      tts = {
        provider = "edge";
        edge.voice = "en-US-AriaNeural";
        elevenlabs.voice_id = "pNInz6obpgDQGcFmaJgB";
      };
      stt = {
        enabled = true;
        provider = "local";
        local.model = "base";
      };
      voice = {
        record_key = "ctrl+b";
        max_recording_seconds = 120;
        beep_enabled = true;
      };

      security = {
        allow_private_urls = false;
        redact_secrets = true;
        tirith_enabled = true;
        tirith_fail_open = true;
      };

      sessions = {
        auto_prune = false;
        retention_days = 90;
      };
      x_search = {
        timeout_seconds = 180;
        retries = 2;
      };
      logging.level = "INFO";
    };
  };
}
