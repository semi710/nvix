# Architecture

## Flake structure

```
nvix/
├── flake.nix                # Entry point - flake-parts + nixvim
├── packages/default.nix      # Three variants: bare, core, full
├── plugins/                  # All plugin modules (auto-discovered)
│   ├── default.nix           # Auto-exporter: *.nix → flake.nvixPlugins.*
│   ├── common/               # Core settings, options, keymaps, icons, colorscheme
│   ├── ai/                   # Copilot + ChatGPT
│   ├── lang/                 # Language-specific LSP + formatters
│   ├── lsp/                  # LSP config, conform, mappings
│   ├── lualine/              # Statusline
│   ├── snacks/               # Snacks.nvim sub-modules
│   ├── blink-cmp.nix         # Completion
│   ├── buffer.nix            # Bufferline + harpoon
│   ├── git.nix               # Gitsigns + diffview + git-conflict
│   ├── treesitter.nix        # Treesitter + context + mini.ai
│   ├── noice.nix             # UI replacement
│   ├── ux.nix                # Colorizer, dressing, fidget, windows
│   ├── autosession.nix       # Session persistence
│   ├── firenvim.nix          # Browser integration
│   ├── leetcode.nix          # LeetCode solver
│   └── tex.nix               # LaTeX (vimtex + texlab + texpresso)
├── overlays/default.nix      # nixpkgs overlays (kulala-core fix)
├── modules/flake/            # Flake-level: pkgs wiring, devshell
└── .github/workflows/        # CI: build + format check, docs deploy, flake update
```

## Auto-discovery

`plugins/default.nix` scans `plugins/` and exports every `.nix` file and
subdirectory as `flake.nvixPlugins.<name>`:

```nix
# plugins/default.nix (simplified)
forAllNixFiles ./. (fn: fn)
# → { common = ./common; git = ./git.nix; lsp = ./lsp; ... }
```

This means adding a new plugin is just creating a file - no registration
needed.

## Package assembly

`packages/default.nix` defines three module lists and passes each to
`makeNixvimWithModule`:

```nix
mkNixvim = module:
  inputs'.nixvim.legacyPackages.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = { inherit (flake) inputs self; };
    inherit module;
  };
```

Each module is a list of `self.nvixPlugins.*` - the auto-discovered
plugin files. Nixvim merges them and produces a wrapped `nvim` binary.

## Shared options

`plugins/common/options.nix` defines custom options consumed across
modules:

| Option | Type | Default | Used by |
|--------|------|---------|---------|
| `nvix.leader` | string | `" "` | `common/default.nix` → `globals.mapleader` |
| `nvix.border` | enum | `"rounded"` | LSP floats, lspsaga, diagnostic, dressing |
| `nvix.transparent` | bool | `true` | kanagawa, tokyonight colorschemes |
| `nvix.icons` | attrs | `{}` | git signs, diagnostic signs, lualine |
| `nvix.mkKey` | attrs | functions | All modules - `mkKeymap`, `wKeyObj` |
| `wKeyList` | list | `[]` | which-key spec (accumulated across modules) |

## Keymap helpers

`plugins/common/functions.nix` provides:

- `mkKeymap mode key action desc` - standard keymap with `silent + noremap`
- `mkKeymapWithOpts mode key action desc opts` - keymap with custom options
- `wKeyObj [key icon group]` - which-key spec entry

These are available as `config.nvix.mkKey.*` in every module.

## LSP strategy

`plugins/lsp/default.nix` auto-enables **all** lspconfig servers with
`package = null` - meaning LSP binaries are picked from the system PATH
or devshell, not installed by nvix. This avoids shipping every language
server in the nvim binary closure.

Exceptions:

- `rust_analyzer` - disabled (handled by `rustaceanvim`)
- `pylsp` - enabled without `package = null` (nixvim builds custom derivation)
- `vue_ls` / `volar` - TS integrations disabled (assert `package != null`)

## Overlays

`overlays/default.nix` patches `kulala-core` to fix a hardcoded WASM
path that breaks in Nix. Applied via flake-parts `perSystem`.

## Devshell

`modules/flake/devshell.nix` provides:

- `just`, `nil` (LSP), `nixd` (LSP), `nix-output-monitor`
- Pre-commit hook: `treefmt` (uses `nixfmt`) on all `.nix` files
