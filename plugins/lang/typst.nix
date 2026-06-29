{ pkgs, lib, ... }:
{
  plugins.lsp.servers.tinymist.enable = true;

  plugins.conform-nvim.settings = {
    formatters_by_ft.typst = [ "typstyle" ];
    formatters.typstyle.command = lib.getExe pkgs.typstyle;
  };

  plugins.typst-preview = {
    enable = true;
  };
}
