# Variants

nvix exports three pre-built Neovim binaries. Each is a `nixvim` package
assembled from plugin modules.

---

## `bare`

Lean variant for reviewing AI-made changes (diffs, hunks, lazygit) and quick
edits on servers or ISOs. No LSP, completion, bufferline or image support.

Ships both `nvim` and an `ai-nvim` bin alias (nixvim only supports
fixed vi/vim aliases), so it can sit next to other variants in
`home.packages`.

| Module | What it does |
|--------|-------------|
| `common` | Options, keymaps, clipboard (OSC52 over SSH), icons, colorscheme, which-key, flash, comment, surround, autopairs, lz-n |
| `git` | Gitsigns, diffview, git-conflict |
| `snacks` | Snacks.nvim: lazygit float (`<leader>gg`), picker, dashboard, notifier, bigfile - image support off, `git` + `lazygit` bundled, ruby provider disabled (works standalone on a fresh machine) |
| `treesitter` | Syntax highlighting (33 curated grammars, regex fallback), context, mini.ai |

## `core` (default)

Everything in `bare`, plus buffer and UI niceties - note it uses the *full*
treesitter grammar set (328 grammars) and snacks image support:

| Module | What it does |
|--------|-------------|
| `buffer` | Bufferline (tabs), harpoon file navigation |
| `ux` | Colorizer, dressing (better UI), lastplace, fidget (LSP notifications), windows.nvim |
| `noice` | UI replacement for cmdline, messages, notifications |
| `lualine` | Statusline (transparent, global) |
| `firenvim` | Neovim in browser textareas (opt-in, takeover = never) |
| `leetcode` | LeetCode solver (custom fork) |
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
bareModules = [ common git treesitter bareExtras ];
coreModules = [ common buffer ux snacks noice git lualine firenvim
  leetcode treesitter blink-cmp lang lsp autosession ai ];
fullModules = coreModules ++ [ tex ];
```

`bareExtras` is an inline module in `packages/default.nix` that re-imports
snacks with image deps dropped, git+lazygit bundled, ruby provider off and
treesitter grammars curated to 33.

Each list is passed to `nixvim.legacyPackages.makeNixvimWithModule`, which
assembles a wrapped `nvim` binary.
