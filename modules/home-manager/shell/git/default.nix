{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "74k1";
    userEmail = "git.t@betsumei.com";
    extraConfig.core.editor = "nvim";
    signing = {
      key = "46F3422F63A313697EAB83D51CF155F76F213503";
      signByDefault = true;
    };
    delta = {
      enable = true;
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
