{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.libqalculate
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "PP Supply Mono";
        use-bold = true;
        show-actions = true;
        terminal = "${lib.getExe pkgs.ghostty} -e";
        layer = "overlay";
        lines = 7;
        width = 48;
        tabs = 2;
        horizontal-pad = 16;
        vertical-pad = 16;
        inner-pad = 8;
        line-height = 24;
      };
      border = lib.mkForce {
        radius = 0;
      };
      colors = lib.mkForce {
        background = "1C1B28FF";
        text = "BFBDCAFF"; # unselected entries
        prompt = "BFBDCAFF"; # prompt character "> "
        placeholder = "938FA8FF"; # placeholder text
        input = "EBE9F1FF"; # input string
        match = "816BFFFF"; # matched substring
        selection = "323246FF"; # bg color of selected entry
        selection-text = "EBE9F1FF"; # fg color
        selection-match = "816BFFFF";
        counter = "72708EFF";
        border = "1C1B28FF";
      };
    };
  };
}
