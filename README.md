<p align="center" style="color:grey">

![image](https://github.com/niksingh710/nvix/assets/60490474/89503d51-ca86-4933-872f-3f60c32202a9)

<div align="center">
<table>
<tbody>
<td align="center">
<img width="2000" height="0"><br>

A **modular** Neovim configuration powered by
[Nixvim](https://github.com/nix-community/nixvim) and
[flake-parts](https://flake.parts/).<br>
<small>Three variants - grab the whole thing or cherry-pick plugins</small><br>
<br><br>
<h3>📚 <a href="https://nvix.semi.sh">nvix.semi.sh</a> - Full Documentation</h3>
<br>
<sub>Variants · Usage · Customization · Architecture · Plugins · Keymaps</sub><br>

![GitHub stars](https://img.shields.io/github/stars/semi710/nvix) ![GitHub forks](https://img.shields.io/github/forks/semi710/nvix) ![GitHub last commit](https://img.shields.io/github/last-commit/semi710/nvix) ![License: MIT](https://img.shields.io/badge/license-MIT-green)

## Star History

<a href="https://www.star-history.com/?repos=semi710%2Fnvix&type=date&logscale&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=semi710/nvix&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=semi710/nvix&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=semi710/nvix&type=date&legend=top-left" />
 </picture>
</a>

<img width="2000" height="0">
</td>
</tbody>
</table>
</div>
</p>

---

## Quick start

```bash
nix run github:semi710/nvix#bare    # minimal
nix run github:semi710/nvix#core    # daily driver
nix run github:semi710/nvix#full    # everything (+ LaTeX)
```

## As a flake input

```nix
{
  inputs.nvix.url = "github:semi710/nvix";

  home.packages = [ inputs.nvix.packages.${pkgs.system}.core ];
}
```

## Customize

```nix
inputs.nvix.packages.${pkgs.system}.core.extend {
  config = {
    vimAlias = true;
    colorschemes.catppuccin.enable = true;
    plugins.leetcode.enable = false;
  };
}
```

Or cherry-pick individual plugins:

```nix
imports = [ inputs.nvix.nvixPlugins.snacks inputs.nvix.nvixPlugins.git ];
```

See the [docs](https://nvix.semi.sh) for full customization, plugin
reference, and keymaps.

---

## Related

- **[ndots](https://github.com/semi710/ndots)** - NixOS config using nvix (5 hosts, per-host variant selection)
- **[nix-wire](https://github.com/semi710/nix-wire)** - Flake auto-wiring library
- **[utils](https://github.com/semi710/utils)** - Utility scripts flake
- **[Nixvim](https://github.com/nix-community/nixvim)** - The foundation nvix is built on
