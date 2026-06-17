{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (config.nvix.mkKey) mkKeymap;
  inherit (config.nvix.icons.diagnostics)
    BoldError
    BoldWarning
    BoldInformation
    BoldHint
    ;
  inherit (lib.nixvim) mkRaw;

  # Enable all lspconfig servers with package = null so binaries are picked
  # up from the system / devshell PATH instead of installing them via nix.
  # Using lib.mkDefault lets manual definitions in other files override these.
  lspconfigServersJson = lib.importJSON "${inputs.nixvim}/generated/lspconfig-servers.json";

  unsupportedServers = lib.importJSON "${inputs.nixvim}/generated/unsupported-lspconfig-servers.json";

  allServerNames = lib.attrNames lspconfigServersJson;

  enabledServers = lib.subtractLists unsupportedServers allServerNames;

  # Servers with null package by default (will use PATH binary).
  # Exclusions:
  # - pylsp: nixvim builds a custom derivation with plugins; package=null conflicts.
  # - rust_analyzer: rustaceanvim plugin handles Rust LSP; enabling both asserts.
  # - vue_ls / volar: ts integrations assert package != null.
  defaultServerConfigs =
    let
      # Most servers: enable=true, package=null (picked up from PATH / devshell)
      base = {
        enable = lib.mkDefault true;
        package = lib.mkDefault null;
      };

      overrides = {
        pylsp = {
          # nixvim builds a custom python-lsp-server derivation with plugins baked in;
          # setting package = null would conflict with its own lib.mkDefault.
          enable = lib.mkDefault true;
        };

        rust_analyzer = {
          # rustaceanvim handles Rust LSP; nixvim asserts you can't have both enabled.
          enable = lib.mkDefault false;
        };

        vue_ls = base // {
          # These integrations reference paths inside the package, so they assert
          # package != null. Disable them when we're using a system binary.
          tslsIntegration = lib.mkDefault false;
          vtslsIntegration = lib.mkDefault false;
        };

        volar = base // {
          tslsIntegration = lib.mkDefault false;
        };
      };
    in
    lib.genAttrs enabledServers (name: overrides.${name} or base);
in
{

  opts = {
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };
  plugins = {
    otter = {
      enable = false;
      settings.buffers = {
        set_filetype = true;
      };
    };
    # TODO: Add mappings in parallel with quickfix
    trouble.enable = true;
    tiny-inline-diagnostic.enable = true;
    lsp = {
      keymaps.extra = [
        (mkKeymap "n" "<leader>lO" "<cmd>lua require('otter').activate()<cr>" "Force Otter")
      ];
      enable = true;
      inlayHints = true;
      servers = defaultServerConfigs // {
        typos_lsp = {
          enable = true;
          extraOptions.init_options.diagnosticSeverity = "Hint";
        };
      };
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>lj" = "goto_next";
          "<leader>lk" = "goto_prev";
        };
      };
    };
    lspsaga = {
      enable = true;
      settings = {
        lightbulb = {
          enable = false;
          virtualText = false;
        };
        outline.keys.jump = "<cr>";
        ui.border = config.nvix.border;
        scrollPreview = {
          scrollDown = "<c-d>";
          scrollUp = "<c-u>";
        };
      };
    };
    nvim-ufo = {
      enable = true;
      settings = {
        provider_selector = # lua
          ''
            function()
              return { "lsp", "indent" }
            end
          '';
        preview.mappings = {
          close = "q";
          switch = "K";
        };
      };
    };
  };

  diagnostic.settings = {
    virtual_text = false;
    underline = true;
    signs = {
      text = mkRaw ''
        {
                [vim.diagnostic.severity.ERROR] = "${BoldError}",
                [vim.diagnostic.severity.WARN] = "${BoldWarning}",
                [vim.diagnostic.severity.INFO] = "${BoldInformation}",
                [vim.diagnostic.severity.HINT] = "${BoldHint}",
              }'';
    };
    severity_sort = true;
    float = {
      border = config.nvix.border;
      source = "always";
      focusable = false;
    };
  };

  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
}
