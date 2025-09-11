{
  inputs,
  config,
  pkgs,
  lib,
  allSecrets,
  ...
}:
let
  # gateway at http://127.0.0.1:42617/ reach it over an SSH tunnel
  dashboard = import ./webui.nix { inherit inputs pkgs lib; };
in
{
  imports = [
    inputs.zeroclaw.nixosModules.default
  ];

  age.secrets."zeroclaw_env" = {
    rekeyFile = "${inputs.self}/secrets/zeroclaw_env.age";
    mode = "600";
  };

  services.zeroclaw.instances.claw = {
    package = import ./package.nix {
      inherit inputs pkgs lib;
    };

    environmentFile = config.age.secrets."zeroclaw_env".path;

    dataDir = "/mnt/btrfs_pool/zeroclaw";

    settings = {
      schema_version = 3;

      providers.models = {
        openrouter.glm_flash = {
          model = "z-ai/glm-5.3-flash";
          api_key = "$OPENROUTER_API_KEY";
          context_window = 1000000;
          fallback = [ "custom.glm_flash" ];
          live_pricing = true;
          max_tokens = 1000000;
          vision = true;
        };

        custom.glm_flash = {
          model = "GLM-5.3-Flash-EXL3";
          uri = "http://192.168.1.73:8888/v1";
          api_key = "N/A";
          context_window = 1000000;
          vision = true;
        };
      };

      agents = {
        assistant = {
          model_provider = "openrouter.glm_flash";
          risk_profile = "assistant";
          runtime_profile = "assistant";
          channels = [
            "discord.home"
            # "telegram.home"
          ];
        };
      };

      runtime_profiles.assistant = {
        agentic = true;
        max_tool_iterations = 128;
        max_history_messages = 500;
        history_pruning = {
          enabled = true;
          max_tokens = 200000;
          keep_recent = 50;
          collapse_tool_results = true;
        };
      };

      runtime.shell = "/run/current-system/sw/bin/bash";

      risk_profiles.assistant = {
        level = "full";
        workspace_only = false;
        block_high_risk_commands = false;
        allowed_commands = [ "*" ];
        forbidden_paths = [
          "/run/agenix"
          "/etc/ssh"
          "/root"
        ];
      };

      web_search = {
        enabled = true;
        search_provider = "brave";
        brave_api_key = "$BRAVE_SEARCH_API_KEY";
      };

      memory = {
        types.enabled = true;
        audit_enabled = true;
        search_mode = "bm25";
      };

      shell_tool.timeout_secs = 3600;

      skills = {
        skill_creation.enabled = true;
        # install_suggestions.enabled = true;
        # skill_improvement.enabled = true;
        allow_scripts = true;
      };

      mcp.servers = [
        {
          name = "outline";
          transport = "http";
          url = "https://wiki.${allSecrets.global.domain00}/mcp";
          command = "";
          headers.Authorization = "Bearer \${OUTLINE_MCP_TOKEN}"; # envsubst from zeroclaw_env
        }
      ];

      observability.backend = "prometheus";

      onboard_state.quickstart_completed = true;

      channels = {
        ack_reactions = false;
        show_tool_calls = true;

        discord.home = {
          enabled = true;
          bot_token = "$DISCORD_BOT_TOKEN";
          slash_commands = true;
          stream_mode = "off";
          ack_reactions = false;
          archive = true;
        };
      };

      gateway.web_dist_dir = "${dashboard}/share/dashboard";

      peer_groups.discord_home = {
        channel = "discord.home";
        agents = [ "assistant" ];
        external_peers = [ "$DISCORD_ALLOWED_USER" ];
      };

      # Telegram later: requires TELEGRAM_BOT_TOKEN
      # channels.telegram.home = {
      #   enabled = true;
      #   bot_token = "$TELEGRAM_BOT_TOKEN";
      #   allowed_users = [ "<telegram-user-id>" ];
      # };
    };
  };

  systemd.services."zeroclaw-claw".environment.PATH =
    lib.mkForce "/run/current-system/sw/bin:/run/wrappers/bin";
}
