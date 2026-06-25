# Design Decisions

## Nixvim over raw init.lua

Nixvim gives us type-checked, overridable plugin configuration in Nix.
No runtime plugin manager needed - Nix is the plugin manager.

## Three variants instead of one config

Different machines need different things:

- **bare** for ISOs and servers where you just need to edit files
- **core** for daily work - LSP, completion, git, languages
- **full** for LaTeX users who need the full texlive scheme

This avoids shipping gigabytes of LaTeX deps to machines that never
compile PDFs.

## Plugin auto-discovery

`plugins/default.nix` scans the directory and exports everything. No
manual registration - drop a `.nix` file, it's available as
`inputs.nvix.nvixPlugins.<name>`.

## `package = null` LSP strategy

Bundling every language server in the nvim closure would make it huge.
Instead, all lspconfig servers are enabled with `package = null` - the
binary is expected from the system PATH or devshell. This means:

- `nil` is picked from your NixOS config, not bundled in nvix
- `rust-analyzer` is handled by rustaceanvim (not lspconfig directly)
- `pylsp` is special (nixvim builds a custom derivation with plugins)

## Snacks over Telescope + Neotree + lazy.nvim

Snacks.nvim is a single plugin that provides dashboard, explorer, picker,
lazygit, bigfile, indent, notifier, etc. Replaces 5+ plugins with one.
The picker is fast and integrates with the Snacks UI ecosystem.

## Blink.cmp over nvim-cmp

Blink.cmp is faster (Rust fuzzy by default, though we use Lua impl to
avoid binary issues), has better Copilot integration, and a cleaner
API. nvim-cmp is still widely used but blink is the future.

## OSC52 clipboard

When `SSH_TTY` is set, nvix switches the clipboard to OSC52 - enabling
copy/paste over SSH without extra configuration. This is critical for
fully-CLI-based setups accessed via Tailscale.

## `nvix.mkKey` helpers

Standardizes keymap definitions so every module uses the same format:

```nix
mkKeymap "n" "<leader>ff" "<cmd>:lua Snacks.picker.files()<cr>" "Find Files"
```

`wKeyObj` builds which-key spec entries with icons. Both are available as
`config.nvix.mkKey.*` in every module, accumulated via `wKeyList`.
