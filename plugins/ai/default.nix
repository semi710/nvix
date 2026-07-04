{ inputs, ... }:
{
  imports = inputs.nix-wire.lib.autoImport ./.;
}
