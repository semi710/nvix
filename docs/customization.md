# Customization

nvix is built on Nixvim - every option is overridable. The `.extend`
method lets you layer changes on top of any variant without forking.

---

## Extend a variant

```nix
{ pkgs, inputs, ... }:
let
  nvix = inputs.nvix.packages.${pkgs.system}.core;
in
{
  home.packages = [
    (nvix.extend {
      config = {
        vimAlias = true;
        colorschemes.tokyonight = {
          enable = true;
          settings.style = "night";
        };
        # Disable a plugin
        plugins.leetcode.enable = false;
      };
    })
  ];
}
```

### Override with `mkForce`

When nvix sets a value and you need to replace it entirely:

```nix
nvix.extend {
  config.colorschemes.kanagawa.enable = lib.mkForce false;
  config.colorschemes.catppuccin.enable = true;
}
```

## Change the leader key

```nix
nvix.extend {
  config.nvix.leader = ",";
}
```

Default is `" "` (space).

## Change the border style

```nix
nvix.extend {
  config.nvix.border = "solid";
}
```

Options: `single`, `double`, `rounded` (default), `solid`, `shadow`, `curved`, `bold`, `none`.

## Transparent background

```nix
nvix.extend {
  config.nvix.transparent = false;
}
```

Default is `true`. The kanagawa colorscheme respects this.

## Build your own variant

Import the individual plugin modules you want:

```nix
{ inputs, pkgs, ... }:
let
  nixvim = inputs.nixvim;
in
{
  programs.nixvim = {
    enable = true;
    imports = with inputs.nvix.nvixPlugins; [
      common
      buffer
      ux
      snacks
      git
      lsp
      blink-cmp
      treesitter
      lang
    ];
  };
}
```

## Cherry-pick a single plugin

```nix
{ inputs, ... }: {
  programs.nixvim = {
    enable = true;
    imports = [ inputs.nvix.nvixPlugins.snacks ];
  };
}
```

## How `.extend` works

Every nvix package is a `makeNixvimWithModule` result. Nixvim's `.extend`
method merges a new module into the existing config and produces a new
wrapped binary. You can chain multiple `.extend` calls:

```nix
nvix.extend { config.vimAlias = true; }
   .extend { config.plugins.leetcode.enable = false; }
```

## Custom colorschemes

nvix ships with kanagawa enabled and catppuccin/tokyonight defined but
disabled. To switch:

```nix
nvix.extend {
  config = {
    colorschemes.kanagawa.enable = lib.mkForce false;
    colorschemes.catppuccin.enable = true;
  };
}
```

## How ndots customizes nvix

ndots [extends nvix](https://github.com/semi710/ndots) with:

```nix
nvix.extend {
  config = {
    vimAlias = true;
    plugins.codesnap.settings.snapshot_config.watermark = {
      font_family = "CaskaydiaCove Nerd Font";
    };
    colorschemes = import ./colorschemes.nix { inherit lib; };
  };
}
```

Where `colorschemes.nix` disables catppuccin and overrides base colors to
pure black (`#000000`).
