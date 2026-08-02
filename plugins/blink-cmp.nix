{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    luasnip.enable = true;
    blink-cmp = {
      enable = true;
      settings = {
        # Use Lua implementation to avoid pre-built binary download issues
        fuzzy.implementation = "lua";

        completion.menu.border = "rounded";
        # Don't preselect the first item; <C-j>/<C-n> picks index 1 on first press.
        completion.list.selection.preselect = false;
        keymap = {
          "<C-j>" = [
            "select_next"
            "fallback"
          ];
          "<C-k>" = [
            "select_prev"
            "fallback"
          ];

          "<c-l>" = [
            "snippet_forward"
            "fallback"
          ];
          "<c-h>" = [
            "snippet_backward"
            "fallback"
          ];
          "<C-u>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-d>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<C-space>" = [
            (
              # lua
              mkRaw ''
                function(cmp)
                  local ok,_ = pcall(require, "copilot")
                    if ok then
                      vim.g.copilot_no_tab_map = true
                      vim.g.copilot_assume_mapped = true
                      vim.g.copilot_tab_fallback = ""

                      local suggestion = require("copilot.suggestion")
                      if suggestion.is_visible() then
                        suggestion.accept()
                      else
                        if cmp.snippet_active() then
                        return cmp.select_and_accept()
                        else
                        return cmp.accept()
                        end
                      end
                    end
                  end
              ''
            )
          ];
        };
      };
    };
  };
}
