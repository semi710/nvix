{ config, ... }:

let
  inherit (config.nvix.mkKey) wKeyObj;
in
{
  wKeyList = [
    (wKeyObj [
      "<leader>R"
      "󱞒"
      "Http Requests"
    ])
  ];
  plugins = {
    kulala = {
      enable = true; # for rest api (alter to insomnia and postman)
      settings = {
        global_keymaps = true;
        global_keymaps_prefix = "<leader>R";
        kulala_keymaps_prefix = "";
        # Free <C-h>/<C-l> for smart-splits; use H/L for tab switching
        kulala_keymaps = {
          "Previous tab" = {
            __unkeyed-1 = "H";
            __unkeyed-2 = {
              __raw = "function() require('kulala.ui').show_previous_tab() end";
            };
            mode = [ "n" ];
          };
          "Next tab" = {
            __unkeyed-1 = "L";
            __unkeyed-2 = {
              __raw = "function() require('kulala.ui').show_next_tab() end";
            };
            mode = [ "n" ];
          };
          # H was "Show headers" — remap to gh to keep it accessible
          "Show headers" = {
            __unkeyed-1 = "gh";
            __unkeyed-2 = {
              __raw = "function() require('kulala.ui').show_headers() end";
            };
          };
        };
      };
      lazyLoad = {
        enable = true;
        settings = {
          ft = [
            "http"
            "rest"
          ];
        };
      };
    };
    ts-autotag.enable = true;
    ts-comments.enable = true;
    lsp.servers = {
      ts_ls.enable = true;
      tailwindcss.enable = true;
      svelte.enable = true;
      jsonls.enable = true;
      html.enable = true;
      eslint.enable = true;
      emmet_ls.enable = true;
      cssls.enable = true;
      biome.enable = true;
    };
  };
}
