{
  lib,
  pkgs,
  config,
  ...
}: {
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
    };
  };
}
