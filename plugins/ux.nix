{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.windows-nvim
  ];
  extraConfigLua = # lua
    ''
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup({
        ignore = {
          filetype = { "snacks_picker_list", "snacks_layout_box", "snacks_picker_input" },
        },
      })
    '';

  plugins = {
    colorizer = {
      enable = true;
      # Only needed once a buffer is displayed; defers ~3ms of startup.
      lazyLoad.settings.event = [
        "BufRead"
        "BufNewFile"
      ];
      settings = {
        filetypes = {
          __unkeyed = "*";
        };
        user_default_options = {
          names = true;
          RRGGBBAA = true;
          AARRGGBB = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
          tailwind = true;
          mode = "virtualtext";
          virtualtext = "■";
          # Re-highlighting on every text change is a per-keystroke cost;
          # updating on read/enter is enough for color swatches.
          always_update = false;
        };
      };
    };
    dressing = {
      enable = true;
      settings.input.mappings.n = {
        "q" = "Close";
        "k" = "HistoryPrev";
        "j" = "HistoryNext";
      };
    };
    lastplace.enable = true;
    fidget = {
      enable = true;
      settings = {
        progress.display.progress_icon = [ "moon" ];
        notification.window = {
          relative = "editor";
          winblend = 0;
          border = "none";
        };
      };
    };
  };
}
