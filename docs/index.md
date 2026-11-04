# nvix

A modular, reproducible Neovim configuration built with
[Nixvim](https://github.com/nix-community/nixvim) and
[flake-parts](https://flake.parts/).

Every plugin is a standalone Nix module. Grab the whole thing as a
pre-built `nvim` binary, or cherry-pick individual plugins into your own
Nixvim config.

Consumed by [ndots](https://ndots.semi.sh) <a href="https://github.com/semi710/ndots" target="_blank">:fontawesome-brands-github:</a>, auto-wired with [nix-wire](https://nix-wire.semi.sh) <a href="https://github.com/semi710/nix-wire" target="_blank">:fontawesome-brands-github:</a>, utilities from [utils](https://utils.semi.sh) <a href="https://github.com/semi710/utils" target="_blank">:fontawesome-brands-github:</a>.

---

## Three variants

| Variant | Use case | Includes |
|---------|----------|----------|
| `bare` | Review AI changes / minimal editing | common, git, snacks (lazygit, no image deps), treesitter (33 grammars) |
| `core` | Daily driver (default) | bare features + buffer, ux, noice, lualine, firenvim, leetcode, blink-cmp, lang, lsp, autosession, AI - full grammars + image support |
| `full` | Everything | core + LaTeX (vimtex, texlab, texpresso) |

## Quick start

```bash
nix run github:semi710/nvix#bare    # minimal / AI diff review
nix run github:semi710/nvix#core    # daily driver
nix run github:semi710/nvix#full    # everything
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

## Docs

Docs are served at [nvix.semi.sh](https://nvix.semi.sh). To preview locally:

```bash
just doc
```
