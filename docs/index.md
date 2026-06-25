# nvix

A modular, reproducible Neovim configuration built with
[Nixvim](https://github.com/nix-community/nixvim) and
[flake-parts](https://flake.parts/).

Every plugin is a standalone Nix module. Grab the whole thing as a
pre-built `nvim` binary, or cherry-pick individual plugins into your own
Nixvim config.

Consumed by [ndots](https://ndots.semi.sh) <a href="https://github.com/semi710/ndots" target="_blank"><sub>:fontawesome-brands-github:</sub></a>, auto-wired with [nix-wire](https://nix-wire.semi.sh) <a href="https://github.com/semi710/nix-wire" target="_blank"><sub>:fontawesome-brands-github:</sub></a>, utilities from [utils](https://utils.semi.sh) <a href="https://github.com/semi710/utils" target="_blank"><sub>:fontawesome-brands-github:</sub></a>.

---

## Three variants

| Variant | Use case | Includes |
|---------|----------|----------|
| `bare` | Servers, quick edits, ISOs | common, buffer, ux, snacks |
| `core` | Daily driver (default) | bare + git, LSP, treesitter, completion, languages, AI, noice, lualine, autosession |
| `full` | Everything | core + LaTeX (vimtex, texlab, texpresso) |

## Quick start

```bash
nix run github:semi710/nvix#bare    # minimal
nix run github:semi710/nvix#core   # daily driver
nix run github:semi710/nvix#full   # everything
```

Or as a flake input:

```nix
{
  inputs.nvix.url = "github:semi710/nvix";

  outputs = { self, nixpkgs, nvix, ... }@inputs: {
    home.packages = [
      nvix.packages.${pkgs.system}.core
    ];
  };
}
```

See [Variants](variants.md) for what's in each, [Usage](usage.md) for full
integration, and [Customization](customization.md) for extending and
overriding.
