# Plugin Reference

All plugins are auto-discovered from `plugins/` and available as
`inputs.nvix.nvixPlugins.<name>`.

---

## common

Core Neovim settings: options, clipboard (OSC52 over SSH), autocommands
(yank highlight, file watcher, popup auto-close), Lua byte-compilation.

**Sub-modules** (auto-imported):

| File | What it does |
|------|-------------|
| `options.nix` | Custom options: `nvix.leader`, `nvix.border`, `nvix.transparent`, `nvix.icons`, `nvix.mkKey` |
| `functions.nix` | `mkKeymap`, `mkKeymapWithOpts`, `wKeyObj` helpers |
| `mappings.nix` | General keymaps: save, move lines, splits, quickfix, flash search, black-hole register for x/c |
| `plugins.nix` | cord, remote-nvim, codesnap, direnv, gx, comment, tmux-navigator, smart-splits, web-devicons, nvim-surround, autopairs, trim, lz-n, flash, visual-multi, which-key |
| `colorscheme.nix` | kanagawa (enabled), catppuccin (disabled), tokyonight (disabled) |
| `icons.nix` | Nerd Font icons for kind, git, UI, diagnostics, misc |

## buffer

Bufferline (tab bar) with diagnostics, harpoon file navigation, buffer
sorting, tab management. `<Shift-h/l>` to cycle buffers.

## ux

- **colorizer** - color hex/rgb/hsl preview with Tailwind support
- **dressing** - better `vim.ui.select` and `vim.ui.input`
- **lastplace** - remember cursor position per file
- **fidget** - LSP progress notifications
- **windows.nvim** - window management plugin

## snacks

[Snacks.nvim](https://github.com/folke/snacks.nvim) - modular utility kit:

- **dashboard** - startup screen with GitHub notifications, issues, PRs, git status
- **explorer** - file explorer (sidebar, right-aligned, 40-width)
- **picker** - fuzzy finder (replaces Telescope): files, grep, buffers, LSP symbols, commands, keymaps, undo, etc.
- **lazygit** - lazygit integration with remote-nvim support
- **bigfile** - fast loading for large files
- **indent** - indent guides
- **words** - LSP word navigation
- **image** - image display in markdown/code
- **notifier** - notification system
- **todo-comments** - highlight TODO/FIXME comments
- **neoscroll** - smooth scrolling
- **statuscolumn** - custom status column

## blink-cmp

Completion via [blink.cmp](https://github.com/Saghen/blink-cmp) with
LuaSnip snippets. Copilot integration on `<C-space>`. Lua fuzzy
implementation (avoids pre-built binary issues).

## git

- **gitsigns** - git signs, hunks navigation, blame, staging
- **diffview** - git diff viewer
- **git-conflict** - merge conflict resolution UI

## treesitter

Treesitter highlighting + indentation + folding, treesitter-context
(sticky context), mini.ai (text objects), sleuth (auto-detect indent).

## lsp

All lspconfig servers are enabled by default with `package = null`,
meaning the editor expects the LSP binary to already be on the system
PATH (installed via system packages, devshell, etc). This lets you
use any LSP that happens to be available without declaring it in nix.

When a language file explicitly sets `enable = true`, the `highestPrio`
check detects the priority drop (1000 -> 100) and swaps `package` to
the nixpkgs derivation automatically - so the LSP binary is installed
and managed by nix. No helper function needed.

### How it works

The Nix module system merges definitions before evaluating them. After
merging, `enable = mkDefault true` (our default) and `enable = true`
(a language file) produce the same value - there's no flag to tell them
apart at evaluation time.

But `options.<path>.highestPrio` exposes the winning definition's
priority. This is a real nixpkgs feature - nixpkgs itself uses it in
`version.nix` to check if `system.stateVersion` was explicitly set.

Priority values:
- `mkDefault` = 1000 (our default `enable`)
- bare value = 100 (language file's `enable = true`)
- option default = 1500 (unused here)

The logic in `lsp/default.nix`:

```nix
mkServerConfig = name: let
  pkgName = nixvimPackages.${name} or null;
  userEnabled = (options.plugins.lsp.servers.${name}.enable.highestPrio or 1500) < 1000;
in {
  enable = lib.mkDefault true;
  package = if userEnabled && pkgName != null
    then pkgs.${pkgName}        # user set enable = true -> install nix package
    else lib.mkDefault null;    # only our default -> use PATH
};
```

| Scenario | `enable` priority | `highestPrio` | `package` |
|---|---|---|---|
| No language file sets it | 1000 (our `mkDefault`) | 1000 | `null` (PATH binary) |
| Language file sets `enable = true` | 100 (bare value wins) | 100 | `pkgs.<nixpkg>` (installed) |

Package name lookup uses nixvim's own `packages.nix` mapping, so
`bashls` resolves to `pkgs.bash-language-server`, `marksman` to
`pkgs.marksman`, etc. - no manual package name lookup needed.

Exclusions: `rust_analyzer` (rustaceanvim handles it), `pylsp`
(nixvim builds custom derivation), `vue_ls`/`volar` (TS integration
assertions).

Plus:

- **lspsaga** - code actions, hover, rename, outline, diagnostic navigation
- **trouble** - diagnostics/references list
- **tiny-inline-diagnostic** - inline diagnostic display
- **nvim-ufo** - LSP-powered folding
- **conform.nvim** - formatter with LSP fallback

## lang

| Language | LSP | Formatter | Extras |
|----------|-----|-----------|--------|
| Nix | `nil_ls`, `statix` | `nixfmt` | |
| Python | `ruff`, `pyright` | | pyright with organize-imports disabled |
| Rust | `rustaceanvim` | | `crates.nvim` |
| Lua | `lua_ls` | `stylua` | Globals: vim, cmp, Snacks |
| Shell | `bashls` | `shellcheck`, `shellharden`, `shfmt` | |
| TOML | `taplo` | `taplo format` | |
| Typst | `tinymist` | `typstyle` | `typst-preview` |
| Haskell | `hls` | | |
| Web | `ts_ls`, `tailwindcss`, `svelte`, `html`, `cssls`, `eslint`, `emmet_ls`, `jsonls`, `biome` | | `ts-autotag`, `ts-comments` |
| Markdown | `marksman` | | mkdnflow, render-markdown, glow, markdown-preview, img-clip |
| HTTP | | | kulala (REST client, lazy-loaded on `http`/`rest` ft) |

## noice

UI replacement for cmdline, search, messages. Routes shell stdout/stderr
to notifications. LSP hover/signature/progress disabled (handled by
lspsaga).

## lualine

Transparent global statusline. No background, minimal separators.

## autosession

Session persistence with git-branch awareness. Save/restore/list/delete
sessions via `<leader>q*` keys.

## firenvim

Neovim in browser textareas. Takeover mode = `never` (opt-in per
textarea).

## leetcode

LeetCode problem solver. Uses a custom fork of leetcode.nvim. Default
language: `python3`.

## ai

Copilot suggestions (auto-trigger in markdown too) + ChatGPT plugin for
code actions (grammar, translate, docstring, tests, optimize, fix bugs,
explain, summarize).

## tex

LaTeX editing: vimtex (with full texlive scheme), texlab LSP, texpresso
live preview. Local leader = `<leader>t`, compile to `.build/` directory.
