{ pkgs, lib, ... }:
{
  plugins = {
    lsp.servers.lua_ls = {
      enable = true;
      settings.diagnostics = {
        disable = [ "miss-name" ];
        globals = [
          "vim"
          "cmp"
          "Snacks"
        ];
      };
    };
    conform-nvim.settings = {
      formatters_by_ft.lua = [ "stylua" ];
      formatters.stylua = {
        command = lib.getExe pkgs.stylua;
      };
    };
  };
}
