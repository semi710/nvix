# Variants

nvix exports three pre-built Neovim binaries. Each is a `nixvim` package
assembled from plugin modules.

---

## `bare`

Minimal setup for servers, quick edits, and ISOs.

| Module | What it does |
|--------|-------------|
| `common` | Options, keymaps, clipboard (OSC52 over SSH), icons, colorscheme (kanagawa), which-key, flash, comment, surround, autopairs, trim, direnv, gx, tmux-navigator, smart-splits, cord (Discord presence), remote-nvim, codesnap, visual-multi, lz-n |
| `buffer` | Bufferline (tabs), harpoon file navigation |
| `ux` | Colorizer, dressing (better UI), lastplace, fidget (LSP notifications), windows.nvim |
| `snacks` | Snacks.nvim: dashboard, explorer, picker, lazygit, bigfile, indent, words, image, notifier, todo-comments, neoscroll |

## `core` (default)

Everything in `bare`, plus:

| Module | What it does |
|--------|-------------|
| `noice` | UI replacement for cmdline, messages, notifications |
| `git` | Gitsigns, diffview, git-conflict |
| `lualine` | Statusline (transparent, global) |
| `firenvim` | Neovim in browser textareas (opt-in, takeover = never) |
| `leetcode` | LeetCode solver (custom fork) |
| `treesitter` | Treesitter highlighting, context, mini.ai, sleuth |
| `blink-cmp` | Completion engine (blink.cmp + luasnip), Copilot integration |
| `lang` | Language servers: Nix, Python, Rust, Lua, Shell, TOML, Typst, Haskell, Web (TS, HTML, CSS, Tailwind, Svelte, JSON, ESLint, Biome), Markdown (obsidian, render-markdown, glow, markdown-preview, img-clip), HTTP (kulala) |
| `lsp` | All lspconfig servers (auto-enabled, package = null → use system PATH), lspsaga, trouble, tiny-inline-diagnostic, nvim-ufo (folding), conform.nvim (formatter) |
| `autosession` | Session persistence with git-branch awareness |
| `ai` | Copilot (suggestions + chatgpt plugin) |

## `full`

Everything in `core`, plus:

| Module | What it does |
|--------|-------------|
| `tex` | Vimtex, texlab (LSP), texpresso (live preview), full texlive scheme |

---

## Module composition

```nix
# packages/default.nix
bareModules = [ common buffer ux snacks ];
coreModules = bareModules ++ [ noice git lualine firenvim leetcode
  treesitter blink-cmp lang lsp autosession ai ];
fullModules = coreModules ++ [ tex ];
```

Each list is passed to `nixvim.legacyPackages.makeNixvimWithModule`, which
assembles a wrapped `nvim` binary.
