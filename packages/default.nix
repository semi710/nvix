{
  pkgs,
  flake,
  inputs',
  self',
  lib,
  ...
}:
let
  mkNixvim =
    module:
    inputs'.nixvim.legacyPackages.makeNixvimWithModule {
      inherit pkgs;
      extraSpecialArgs = { inherit (flake) inputs self; };
      inherit module;
    };
  inherit (flake) self;
  # Minimal lean variant: review AI-made changes (diffs, hunks, lazygit) and
  # quick edits. Replaces the old bare: smaller download, git + highlighting.
  # snacks without its image deps; bundles git+lazygit so the package works
  # standalone on a fresh machine
  bareExtras =
    { config, ... }:
    {
      imports = [ self.nvixPlugins.snacks ];
      # mkForce replaces snacks' imagemagick/ghostscript/mermaid-cli (~0.9 GiB)
      extraPackages =
        with pkgs;
        lib.mkForce [
          git
          lazygit
          dwt1-shell-color-scripts # snacks dashboard shells out to `colorscript`
        ];
      # ruby provider is dead weight here; treesitter does the highlighting
      withRuby = false;
      plugins.snacks.settings.image = lib.mkForce { enabled = false; };
      # default ships all 328 grammars; ~30 cover the languages a diff review
      # actually meets, unknown files fall back to regex highlighting
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        bash
        c
        cpp
        css
        diff
        gitcommit
        git_config
        git_rebase
        go
        haskell
        html
        ini
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        prisma
        proto
        python
        regex
        rust
        sql
        svelte
        toml
        tsx
        typescript
        typst
        vim
        vimdoc
        xml
        yaml
      ];
    };
  bareModules = [
    # every module below needs its keymap helpers and base options
    self.nvixPlugins.common

    # diffview, gitsigns, git-conflict
    self.nvixPlugins.git

    # syntax highlighting for reading diffs
    self.nvixPlugins.treesitter

    bareExtras
  ];
  # nixvim only ships fixed vi/vim aliases, so wrap to add an `ai-nvim` bin
  bare =
    let
      bareNvim = mkNixvim bareModules;
      joined = pkgs.symlinkJoin {
        name = "nvix-bare";
        paths = [ bareNvim ];
        postBuild = ''
          ln -sfn nvim $out/bin/ai-nvim
        '';
      };
    in
    joined.overrideAttrs (old: {
      meta = (old.meta or { }) // {
        mainProgram = "ai-nvim";
      };
      passthru = (old.passthru or { }) // {
        inherit (bareNvim) extend;
      };
    });
  coreModules = [
    # Core functionality and improvements
    self.nvixPlugins.common
    self.nvixPlugins.buffer
    self.nvixPlugins.ux # better user experience
    self.nvixPlugins.snacks

    # noice for cmdline
    self.nvixPlugins.noice

    # Git and version control
    self.nvixPlugins.git

    # UI and appearance
    self.nvixPlugins.lualine
    self.nvixPlugins.firenvim
    self.nvixPlugins.leetcode

    # Code editing and syntax
    self.nvixPlugins.treesitter
    self.nvixPlugins.blink-cmp
    self.nvixPlugins.lang
    self.nvixPlugins.lsp

    # Productivity
    self.nvixPlugins.autosession
    self.nvixPlugins.ai
  ];
  fullModules = coreModules ++ [
    self.nvixPlugins.tex
  ];
in
{
  packages = {
    default = self'.packages.core;
    inherit bare;
    core = mkNixvim coreModules;
    full = mkNixvim fullModules;
  };
}
