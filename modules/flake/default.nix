{ inputs, self, ... }:
{
  imports = [
    ./devshell.nix
  ];
  perSystem =
    { lib, system, ... }:
    {
      # Make our overlay available to the devShell
      # "Flake parts does not yet come with an endorsed module that initializes the pkgs argument.""
      # So we must do this manually; https://flake.parts/overlays#consuming-an-overlay
      _module.args = {
        flake = { inherit inputs self; };
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = lib.attrValues self.overlays;
          config.allowUnfree = true;
        };
      };

      imports = [
        (self + /packages)
      ];
    };
}
