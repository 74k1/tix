{
  config,
  inputs,
  pkgs,
  allSecrets,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = allSecrets.global.me.git.user.name;
          email = allSecrets.global.me.git.user.email;
        };
        core.editor = "nvim";
      };
      signing = {
        key = allSecrets.global.gpg.key;
        signByDefault = true;
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        # whitespace-error-style = "22 reverse";
        line-numbers = true;
        side-by-side = true;
        navigate = true;
        color-only = true;
        max-line-length = 0; # disable trunc
      };
    };
  };
}
