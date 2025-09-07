{
  lib,
  pkgs,
  config,
  ...
}:
{
  # home.packages = with pkgs; [
  #   atuin
  #   zoxide
  # ];

  # age.secrets.test_secret.file = secrets/secret_test.age;

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = ./fastfetch_logo;
        type = "file";
      };
      modules = [
        "break"
        "title"
        "separator"
        {
          type = "os";
          key = "Distro";
          format = "{3}";
        }
        {
          type = "kernel";
          key = "Kernel Version";
          format = "{2}";
        }
        {
          type = "packages";
          format = "{9}";
        }
        "shell"
        "wm"
        "separator"
        {
          type = "cpu";
          format = "{1} - {3} Cores";
        }
        {
          type = "gpu";
          key = "GPU";
          hideType = "integrated";
          format = "{2}";
        }
        {
          type = "memory";
        }
        {
          type = "disk";
        }
      ];
    };
  };
}
