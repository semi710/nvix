{
  # TODO: Make plugins lazy load as now keymap function is added
  description = "Neovim configuration with nix";
  nixConfig = {
    extra-substituters = "https://nvix.cachix.org";
    extra-trusted-public-keys = "nvix.cachix.org-1:qVYAfj2oiH0DF3pSs8OfPYI6B0mAZ+h5mMajN+EOL2E=";
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    # hooks for git
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.flake = false;
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      _module.args = { inherit inputs; };
      imports = [
        ./modules/flake
        ./overlays
        ./plugins
      ];
    };
}
