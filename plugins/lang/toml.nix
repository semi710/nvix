{ pkgs, lib, ... }:
{
  plugins.lsp.servers.taplo.enable = true;
  plugins.conform-nvim.settings = {
    formatters_by_ft.toml = [ "taplo" ];
    formatters.taplo = {
      command = lib.getExe pkgs.taplo;
      args = [ "format" ];
    };
  };
}
