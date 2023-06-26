{ lib, pkgs, config, ... }:

{
  imports = [];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraConfig = ''
      set shiftwidth=2 softtabstop=2 expandtab
      set number relativenumber
      set clipboard=unnamedplus
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      comment-nvim
      telescope-nvim
      nvim-treesitter
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = builtins.readFile ./cfg/autopairs.lua;
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = builtins.readFile ./cfg/colorizer.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/indent_blankline.lua;
      }
      {
        plugin = alpha-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/alpha.lua;
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/catppuccin.lua;
      }
    ];
  };
}
