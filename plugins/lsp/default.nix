{
  lib,
  config,
  options,
  pkgs,
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

  lspconfigServersJson = lib.importJSON "${inputs.nixvim}/generated/lspconfig-servers.json";
  unsupportedServers = lib.importJSON "${inputs.nixvim}/generated/unsupported-lspconfig-servers.json";
  allServerNames = lib.attrNames lspconfigServersJson;
  enabledServers = lib.subtractLists unsupportedServers allServerNames;

  # nixvim maps server names to nixpkgs package names.
  nixvimPackages = (import "${inputs.nixvim}/modules/lsp/servers/packages.nix").packages;

  # All servers enabled by default with package = null (use PATH binary).
  # When a language file explicitly sets enable = true (priority 100, beating
  # our mkDefault 1000), highestPrio drops below 1000 and we swap package to
  # the nixpkgs derivation automatically. No mkLsp helper needed.
  mkServerConfig =
    name:
    let
      pkgName = nixvimPackages.${name} or null;
      userEnabled = (options.plugins.lsp.servers.${name}.enable.highestPrio or 1500) < 1000;
    in
    {
      enable = lib.mkDefault true;
      package = if userEnabled && pkgName != null then pkgs.${pkgName} else lib.mkDefault null;
    };

  overrides = {
    pylsp.enable = lib.mkDefault true;
    rust_analyzer.enable = lib.mkDefault false;
    vue_ls = (mkServerConfig "vue_ls") // {
      tslsIntegration = lib.mkDefault false;
      vtslsIntegration = lib.mkDefault false;
    };
    volar = (mkServerConfig "volar") // {
      tslsIntegration = lib.mkDefault false;
    };
  };

  defaultServerConfigs = lib.genAttrs enabledServers (
    name: overrides.${name} or (mkServerConfig name)
  );
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
