{ lib, pkgs, config, ... }:

let
  tsukiyo-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tsukiyo-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "74k1";
      repo = "tsukiyo.nvim";
      rev = "fa08090d321bc5971aa30f2d423ab30f820b635e";
      hash = "sha256-8gRjl8aGxHPERIZ+P3KUQmDZPJxvXOMnB47I9TkH9/U=";
    };
  };
  nix-update-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "nix-update-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "reo101";
      repo = "nix-update.nvim";
      rev = "28e92807add9fecaa64c35999069bceea045da34";
      hash = "sha256-C4Pe5xjdXevCzj5Q1sGpPrieeY1JdGyJyuqVQ8ROcr0=";
    };
  };
  hmts-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "hmts-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "calops";
      repo = "hmts.nvim";
      rev = "v1.2.5";
      hash = "sha256-V5dwIJdxBulFVKk1iSlf4H5NRz1UH7uYQeMvwtgkpIs=";
    };
  };
  # image-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "image-nvim";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "3rd";
  #     repo = "image.nvim";
  #     rev = "2a618c86d9f8fd9f7895d12b55ec2f31fd14fa05";
  #     sha256 = "sha256-6nFzUchDQIvaTOv4lZ10q66m/ntU3dgVnlfBRodW+0Y=";
  #   };
  # };
  indentmini-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "indentmini-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvimdev";
      repo = "indentmini.nvim";
      rev = "03c24a3e76eb9d65ddbd080aa2bfb6d3d6c85058";
      hash = "sha256-qJgB/Ap2SM/vxlZ8F8kIS/AwtzkNPrvC0b30Rw/i8Tc=";
    };
  };
in
{
  imports = [];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaPackages = ps: [
      ps.magick # for image.nvim
    ];
    extraPackages = [
      pkgs.ripgrep # For Telescope live-grep
      pkgs.bash-language-server # Bash :-)
      pkgs.nixd # Nix Language Server
      pkgs.alejandra # Nix Formatter
      pkgs.rust-analyzer # Rust Language Server
      pkgs.vscode-langservers-extracted # HTML, CSS, JSON, ESLINT Language Server
      # pkgs.superhtml # HTML Language Server
      pkgs.emmet-ls # Emmet Language Server (cool snippets)
      pkgs.imagemagick # for image.nvim
      pkgs.curl # for image.nvim remote images
      # pkgs.nodejs # for copilot-lua
    ];
    extraConfig = ''
      set shiftwidth=2 softtabstop=2 expandtab
      set number relativenumber
      set clipboard=unnamedplus

      " keybinds
      lua vim.api.nvim_create_user_command("E", "Oil", {})
      "lua vim.keymap.set("n", "-", function() vim.cmd.Oil() end, {})

      " set t_Co=0
      " set background=none
      " lua vim.opt.termguicolors = false
      "let g:netrw_liststyle = 3
      
      " Autocommands for vim-table-mode
      "augroup TableModeSetup
      "  autocmd!
      "  autocmd FileType markdown TableModeEnable
      "  autocmd BufEnter * if &ft != 'markdown' | TableModeDisable | endif
      "augroup END
      " lua require'./plg/markdown_headings.lua'.init()
    '';
    plugins = with pkgs.vimPlugins; [
      # neo-tree-nvim
      # oxocarbon-nvim
      # copilot-vim
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp-emoji
      cmp_luasnip
      comment-nvim
      hmts-nvim
      luasnip
      nvim-tree-lua
      telescope-nvim
      venn-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      vim-nix
      # vim-table-mode
      vim-shellcheck
      # {
      #   plugin = oxocarbon-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/oxocarbon.lua;
      # }
      {
        plugin = tsukiyo-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/tsukiyo.lua;
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./cfg/TSconfig.lua;
      }
      # {
      #   plugin = copilot-cmp;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/copilot-cmp.lua;
      # }
      # {
      #   plugin = copilot-lua;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/copilot-lua.lua;
      # }
      {
        plugin = markview-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/markview.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./cfg/lspconfig.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./cfg/cmp.lua;
      }
      {
        plugin = fidget-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/fidget.lua;
      }
      {
        plugin = indentmini-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/indentmini.lua;
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/oil.lua;
      }
      {
        plugin = nix-update-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/nix-update.lua;
      }
      # {
      #   plugin = clipboard-image-nvim;
      #   type = "lua";
      #   config = builtins.readFile ./cfg/clipboard-image.lua;
      # }
      {
        plugin = img-clip-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/img-clip.lua;
      }
      {
        plugin = image-nvim;
        type = "lua";
        config = builtins.readFile ./cfg/image.lua;
      }
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
    ];
  };
}
