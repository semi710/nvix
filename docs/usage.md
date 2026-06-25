# Usage

## Run directly

No install needed — `nix run` pulls and runs nvix instantly:

```bash
nix run github:semi710/nvix#bare
nix run github:semi710/nvix#core
nix run github:semi710/nvix#full
```

Files open as arguments:

```bash
nix run github:semi710/nvix#core -- file.py
```

## As a flake input

### Home Manager

```nix
{
  inputs.nvix.url = "github:semi710/nvix";

  outputs = { self, nixpkgs, nvix, ... }@inputs: {
    homeConfiguration = {
      "user@host" = inputs.home-manager.lib.homeManagerConfiguration {
        modules = [({ pkgs, ... }: {
          home.packages = [ nvix.packages.${pkgs.system}.core ];
          home.sessionVariables.EDITOR = "nvim";
        })];
      };
    };
  };
}
```

### NixOS

```nix
{ pkgs, inputs, ... }: {
  environment.systemPackages = [ inputs.nvix.packages.${pkgs.system}.core ];
}
```

### Nixvim (cherry-pick plugins)

If you already have a Nixvim config, import individual nvix plugin modules:

```nix
{ inputs, ... }: {
  # Each plugin file is a nixvim module
  imports = [
    inputs.nvix.nvixPlugins.common
    inputs.nvix.nvixPlugins.git
    inputs.nvix.nvixPlugins.lsp
    inputs.nvix.nvixPlugins.blink-cmp
  ];
}
```

### Module path reference

| File | Flake attribute |
|------|-----------------|
| `plugins/foo.nix` | `inputs.nvix.nvixPlugins.foo` |
| `plugins/foo/default.nix` | `inputs.nvix.nvixPlugins.foo` |
| `plugins/sub/foo.nix` | `inputs.nvix.nvixPlugins.foo` (flat name from filename) |

The `plugins/default.nix` auto-discovers every `.nix` file and
subdirectory under `plugins/` and exports them as `flake.nvixPlugins.*`.

## Binary cache

nvix publishes to `nvix.cachix.org`. Add to your flake or system config:

```nix
nix.settings = {
  substituters = [ "https://nvix.cachix.org" ];
  trusted-public-keys = [
    "nvix.cachix.org-1:qVYAfj2oiH0DF3pSs8OfPYI6B0mAZ+h5mMajN+EOL2E="
  ];
};
```

## Development

```bash
git clone --single-branch --branch master https://github.com/semi710/nvix.git
cd nvix
nix develop  # devshell with nixfmt, nil, just, nom
```

Pre-commit runs `nixfmt` on all `.nix` files.
