{ pkgs, config, ... }:
let
  inherit (config.nvix.mkKey) mkKeymap;
in
{
  extraPlugins = with pkgs.vimPlugins; [
    stay-centered-nvim
    mini-icons
  ];
  plugins = {
    # Must have plugins to have a decent flow of work
    cord.enable = true;
    remote-nvim = {
      enable = true;
      package = pkgs.vimPlugins.remote-nvim-nvim.overrideAttrs (_: {
        dontPatchShebangs = true;
      });
    };
    codesnap = {
      enable = true;
      settings = {
        snapshot_config = {
          background.stops = [
            { color = "#00000000"; }
            { color = "#00000000"; }
          ];
          theme = "vercel@https://raw.githubusercontent.com/Railly/one-hunter-vscode/refs/heads/main/themes/OneHunter-Vercel-color-theme.json";
          watermark.content = "";
        };
      };
    };
    direnv.enable = true;
    gx.enable = true;
    comment = {
      enable = true;
      settings = {
        toggler.line = "<leader>/";
        opleader.line = "<leader>/";
      };
    };
    tmux-navigator.enable = true;
    smart-splits.enable = true;
    web-devicons.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    trim.enable = true;
    lz-n.enable = true;
    flash = {
      enable = true;
      settings = {
        modes.char.enabled = false;
      };
    };
    visual-multi.enable = true;
    which-key = {
      enable = true;
      settings.spec = config.wKeyList;
      settings.preset = "helix";
      settings.icons = {
        colors = true;
        mappings = false;
        rules = [
          {
            pattern = "preview";
            icon = "󰋭";
            color = "cyan";
          }
          {
            pattern = "link";
            icon = "󰌷";
            color = "blue";
          }
          {
            pattern = "rename";
            icon = "󰑴";
            color = "yellow";
          }
          {
            pattern = "backlink";
            icon = "󰆋";
            color = "blue";
          }
          {
            pattern = "outgoing";
            icon = "󰈙";
            color = "blue";
          }
          {
            pattern = "yank";
            icon = "󰆴";
            color = "yellow";
          }
          {
            pattern = "numbering";
            icon = "󰲔";
            color = "cyan";
          }
        ];
      };
    };
  };
  opts = {
    timeout = true;
    timeoutlen = 250;
  };
  keymaps = [
    (mkKeymap "n" "<leader>vt" "<cmd>:lua require('flash').treesitter()<cr>" "Select Treesitter Node")
    (mkKeymap "n" "<leader>ut" ":TrimToggle<cr>" "Toggle Trim")
    (mkKeymap "v" "<leader>us" ":CodeSnap<cr>" "SnapShot the selected code")
  ];
}
