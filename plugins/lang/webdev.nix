{
  pkgs,
  config,
  lib,
  ...
}:

let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (lib.nixvim) mkRaw;
in
{
  wKeyList = [
    (wKeyObj [
      "<leader>R"
      "󱞒"
      "Http Requests"
    ])
  ];
  # Kulala variable values change without text edits (env switch, request
  # scripts) but neovim only refreshes inlay hints on text change
  autoCmd = [
    {
      desc = "Refresh kulala inlay hints when variable values change without edits";
      event = [ "FileType" ];
      pattern = [
        "http"
        "rest"
      ];
      callback =
        # lua
        mkRaw ''
          function(args)
            local buf = args.buf
            if vim.b[buf].nvix_kulala_inlay_refresh then return end
            vim.b[buf].nvix_kulala_inlay_refresh = true
            local group = vim.api.nvim_create_augroup("nvix-kulala-inlay", { clear = false })
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
              group = group,
              buffer = buf,
              callback = function()
                -- respects <leader>uh toggle
                if vim.lsp.inlay_hint.is_enabled({ bufnr = buf }) then
                  vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                end
              end,
            })
          end
        '';
    }
  ];
  # kulala probes for parser/kulala_http.dylib on macOS and so misses the
  # .so-named grammar nixpkgs ships as a kulala dependency; without this
  # kulala tries to rebuild the grammar with a tree-sitter CLI the wrapped
  # nvim does not have and never starts its inlay-hint LSP
  extraPlugins = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    (pkgs.runCommand "kulala-http-parser-dylib" { } ''
      mkdir -p $out/parser
      ln -s ${lib.head pkgs.vimPlugins.kulala-nvim.dependencies}/parser/kulala_http.so \
        $out/parser/kulala_http.dylib
    '')
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
