{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "74k1";
          email = "git.t@betsumei.com";
        };
        core.editor = "nvim";
      };
      signing = {
        key = "46F3422F63A313697EAB83D51CF155F76F213503";
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
