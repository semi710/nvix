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
      texlivePackage = pkgs.texliveFull;
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
    if vim.fn.executable('zathura') == 1 then
      vim.g.vimtex_view_method = 'zathura'

      if vim.fn.has('mac') == 1 then
        -- macOS lacks xdotool and /etc/machine-id, so vimtex's built-in
        -- auto-view and synctex break. Use pgrep-based autocmd instead.
        vim.g.vimtex_view_automatic = 0
        vim.g.vimtex_view_zathura_use_synctex = 0
        vim.g.vimtex_view_forward_search_on_start = 0

        vim.api.nvim_create_autocmd('User', {
          pattern = 'VimtexEventCompileSuccess',
          callback = function()
            local pdf_name = vim.fn.fnamemodify(vim.fn.expand('%:t'), ':r') .. '.pdf'
            local running = vim.fn.system('pgrep -nf "zathura.*' .. pdf_name .. '"')
            if #running == 0 then
              vim.cmd('VimtexView')
            end
          end,
        })
      else
        vim.g.vimtex_view_automatic = 1
      end
    end
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
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
      remap = true;
      desc = "Context menu";
      mode = [ "n" ];
      icon = {
        icon = "󰮫";
        color = "purple";
      };
    }
  ];
}
