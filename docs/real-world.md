# Real-world usage

See [ndots](https://ndots.semi.sh) <a href="https://github.com/semi710/ndots" target="_blank">:fontawesome-brands-github:</a> for a complete NixOS + nix-darwin configuration that consumes nvix.

## How ndots uses nvix

ndots adds nvix as a flake input and wraps it in a Home Manager module
with an `nvix.variant` option:

```nix
# modules/home/editor/nvix/default.nix
{
  options.nvix.variant = lib.mkOption {
    type = lib.types.enum [ "bare" "core" "full" ];
    default = "core";
  };

  config = let
    nvix = flake.inputs.nvix.packages.${pkgs.system}.${config.nvix.variant};
  in {
    home.sessionVariables.EDITOR = "nvim";
    home.packages = [
      (nvix.extend {
        config = {
          vimAlias = true;
          colorschemes = import ./colorschemes.nix { inherit lib; };
        };
      })
    ];
  };
}
```

### Per-host variant selection

| Host | Variant | Why |
|------|---------|-----|
| mach | `full` | Personal laptop - needs LaTeX |
| jp-mbp | `full` | MacBook Pro - needs LaTeX |
| semi | `core` | Workstation - no LaTeX needed |
| dsd | `core` | Work desktop - no LaTeX needed |
| virt-* | `core` | VMs - daily driver |
| iso | `bare` | Installer ISO - minimal, fast boot |

Each user config sets `nvix.variant = "...";` and the module handles the
rest. The `.extend` call layers custom colorschemes and `vimAlias` on
top.
