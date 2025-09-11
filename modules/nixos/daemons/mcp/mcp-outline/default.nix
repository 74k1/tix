{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  allSecrets,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.mcp-outline
  ];

  age.secrets = {
    "mcp_outline_api_key" = {
      rekeyFile = "${inputs.self}/secrets/mcp_outline_api_key.age";
      # mode = "770";
      # owner = "outline";
      # group = "outline";
    };
  };

  services.mcp-outline = {
    enable = true;

    # OUTLINE_API_KEY
    environmentFile = config.age.secrets."mcp_outline_api_key".path;

    settings = {
      MCP_HOST = "127.0.0.1";
      MCP_PORT = 3123;
      MCP_TRANSPORT = "streamable-http";
      OUTLINE_DISABLE_AI_TOOLS = true;
      # OUTLINE_DISABLE_DELETE = true;
      OUTLINE_READ_ONLY = true;
      OUTLINE_API_URL = "https://wiki.${allSecrets.global.domain00}/api";
    };
  };
}
