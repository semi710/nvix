# LLM Context

## Goal

A modular, reproducible Neovim configuration built with Nixvim and
flake-parts. Every plugin is a standalone module. Users can use the whole
config, extend it, or cherry-pick individual plugins.

## Constraints

- Built on Nixvim - all options overridable via Nix
- Three variants: bare, core, full - each a pre-built `nvim` binary
- Plugins auto-discovered from `plugins/` directory
- LSP servers use `package = null` → picked from system PATH, not bundled
- Binary cache: `nvix.cachix.org`
- Ponytail mode - minimal, no over-engineering

## Current State

### Done
- Three variants (bare, core, full) with `makeNixvimWithModule`
- Plugin auto-discovery via `forAllNixFiles`
- Shared options: `nvix.leader`, `nvix.border`, `nvix.transparent`, `nvix.mkKey`
- All language support: Nix, Python, Rust, Lua, Shell, TOML, Typst, Haskell, Web, Markdown, HTTP
- Snacks.nvim as the main utility kit (dashboard, explorer, picker, lazygit)
- Blink.cmp completion with Copilot integration
- Git integration (gitsigns, diffview, git-conflict)
- AI (Copilot + ChatGPT plugin)
- LaTeX (vimtex + texlab + texpresso)
- Binary cache on cachix
- Devshell with nixfmt, nil, just, nom
- Docs site (MkDocs Material, nvix.semi.sh)

## Key Decisions

- Snacks.picker over Telescope - lighter, better integration with Snacks ecosystem
- Blink.cmp over nvim-cmp - faster, Lua-first, better Copilot integration
- LSP `package = null` strategy - avoids bundling every language server
- Kanagawa as default colorscheme - catppuccin/tokyonight defined but disabled
- OSC52 clipboard over SSH - works transparently in remote sessions
- `nvix.mkKey` helpers - consistent keymap definitions across all modules
- `wKeyList` accumulation - which-key spec built across modules via list merging
