{ inputs, ... }:
{
  imports = [
    (inputs.git-hooks + /flake-module.nix)
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
      devShells.default = pkgs.mkShell rec {
        name = "nvix";
        meta.description = "Dev environment for nixvim-config";
        inputsFrom = [ config.pre-commit.devShell ];
        packages = with pkgs; [
          just
          nil
          nix-output-monitor
        ];
        shellHook = ''
          echo 1>&2 "🐼: $(id -un) | 🧬: $(nix eval --raw --impure --expr 'builtins.currentSystem') | 🐧: $(uname -r) "
          echo 1>&2 "Ready to work on ${name}!"
        '';
      };
      pre-commit.settings.hooks.treefmt = {
        enable = true;
        entry = "${lib.getExe config.treefmt.build.wrapper}";
      };
    };
}
