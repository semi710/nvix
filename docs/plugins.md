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

All lspconfig servers auto-enabled with `package = null` (use system
PATH). Plus:

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
| Markdown | `markdown_oxide`, `marksman` | | obsidian, render-markdown, glow, markdown-preview, img-clip |
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
