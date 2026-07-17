{ pkgs, config, ... }:
let
  inherit (config.nvix.mkKey) wKeyObj;
in
{

  plugins = {
    texpresso.enable = true;
    lsp.servers.texlab.enable = true;
    vimtex = {
      enable = true;
      texlivePackage = pkgs.texliveSmall;
    };
  };

  extraPackages = [ pkgs.python313Packages.pylatexenc ];
  extraConfigLuaPre = ''
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = ".build" -- you can set here whatever name you desire
    }
    vim.g.vimtex_quickfix_ignore_filters = { 'warning' }
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_mappings_enabled = 0
  '';

  globals.maplocalleader = " t"; # Set the local leader to "<leader>t"

  wKeyList = [
    (wKeyObj [
      "<leader>t"
      ""
      "tex"
    ])
  ];

  # https://github.com/lervag/vimtex/wiki/which-key.nvim-support
  plugins.which-key.settings.spec = [

    {
      __unkeyed-1 = "<localleader>l";
      group = "VimTeX";
      icon = {
        icon = "";
        color = "green";
      };
      mode = [
        "n"
        "x"
      ];
    }
    {
      __unkeyed-1 = "<localleader>ll";
      __unkeyed-2 = "<plug>(vimtex-compile)";
      desc = "Compile";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "green";
      };
    }
    {
      __unkeyed-1 = "<localleader>lL";
      __unkeyed-2 = "<cmd>TeXpresso %<cr>";
      desc = "Live Preview";
      icon = {
        icon = "";
        color = "green";
      };
      mode = [
        "n"
        "x"
      ];
    }
    {
      __unkeyed-1 = "<localleader>lS";
      __unkeyed-2 = "<plug>(vimtex-compile-selected)";
      desc = "Compile selected";
      icon = {
        icon = "";
        color = "green";
      };
      mode = [
        "n"
        "x"
      ];
    }
    {
      __unkeyed-1 = "<localleader>li";
      __unkeyed-2 = "<plug>(vimtex-info)";
      desc = "Information";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lI";
      __unkeyed-2 = "<plug>(vimtex-info-full)";
      desc = "Full information";
      mode = [ "n" ];
      icon = {
        icon = "󰙎";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lt";
      __unkeyed-2 = "<plug>(vimtex-toc-open)";
      desc = "Table of Contents";
      mode = [ "n" ];
      icon = {
        icon = "󰠶";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lT";
      __unkeyed-2 = "<plug>(vimtex-toc-toggle)";
      desc = "Toggle table of Contents";
      mode = [ "n" ];
      icon = {
        icon = "󰠶";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lq";
      __unkeyed-2 = "<plug>(vimtex-log)";
      desc = "Log";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lv";
      __unkeyed-2 = "<plug>(vimtex-view)";
      desc = "View";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "green";
      };
    }
    {
      __unkeyed-1 = "<localleader>lr";
      __unkeyed-2 = "<plug>(vimtex-reverse-search)";
      desc = "Reverse search";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lk";
      __unkeyed-2 = "<plug>(vimtex-stop)";
      desc = "Stop";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "red";
      };
    }
    {
      __unkeyed-1 = "<localleader>lK";
      __unkeyed-2 = "<plug>(vimtex-stop-all)";
      desc = "Stop all";
      mode = [ "n" ];
      icon = {
        icon = "󰓛";
        color = "red";
      };
    }
    {
      __unkeyed-1 = "<localleader>le";
      __unkeyed-2 = "<plug>(vimtex-errors)";
      desc = "Errors";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "red";
      };
    }
    {
      __unkeyed-1 = "<localleader>lo";
      __unkeyed-2 = "<plug>(vimtex-compile-output)";
      desc = "Compile output";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lg";
      __unkeyed-2 = "<plug>(vimtex-status)";
      desc = "Status";
      mode = [ "n" ];
      icon = {
        icon = "󱖫";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lG";
      __unkeyed-2 = "<plug>(vimtex-status-full)";
      desc = "Full status";
      mode = [ "n" ];
      icon = {
        icon = "󱖫";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>lc";
      __unkeyed-2 = "<plug>(vimtex-clean)";
      desc = "Clean";
      mode = [ "n" ];
      icon = {
        icon = "󰃢";
        color = "orange";
      };
    }
    {
      __unkeyed-1 = "<localleader>lh";
      __unkeyed-2 = "<Cmd>VimtexClearCache ALL<cr>";
      desc = "Clear all cache";
      mode = [ "n" ];
      icon = {
        icon = "󰃢";
        color = "grey";
      };
    }
    {
      __unkeyed-1 = "<localleader>lC";
      __unkeyed-2 = "<plug>(vimtex-clean-full)";
      desc = "Full clean";
      mode = [ "n" ];
      icon = {
        icon = "󰃢";
        color = "red";
      };
    }
    {
      __unkeyed-1 = "<localleader>lx";
      __unkeyed-2 = "<plug>(vimtex-reload)";
      desc = "Reload";
      mode = [ "n" ];
      icon = {
        icon = "󰑓";
        color = "green";
      };
    }
    {
      __unkeyed-1 = "<localleader>lX";
      __unkeyed-2 = "<plug>(vimtex-reload-state)";
      desc = "Reload state";
      mode = [ "n" ];
      icon = {
        icon = "󰑓";
        color = "cyan";
      };
    }
    {
      __unkeyed-1 = "<localleader>lm";
      __unkeyed-2 = "<plug>(vimtex-imaps-list)";
      desc = "Input mappings";
      mode = [ "n" ];
      icon = {
        icon = "";
        color = "purple";
      };
    }
    {
      __unkeyed-1 = "<localleader>ls";
      __unkeyed-2 = "<plug>(vimtex-toggle-main)";
      desc = "Toggle main";
      mode = [ "n" ];
      icon = {
        icon = "󱪚";
        color = "green";
      };
    }
    {
      __unkeyed-1 = "<localleader>la";
      __unkeyed-2 = "<plug>(vimtex-context-menu)";
      desc = "Context menu";
      mode = [ "n" ];
      icon = {
        icon = "󰮫";
        color = "purple";
      };
    }
  ];
}
