{ pkgs, ... }:
{
  plugins = {
    mini-ai.enable = true;
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          # TODO: remove once this is fully migrated
          # evaluation warning: Nixvim (plugins.treesitter): `plugins.treesitter.settings.highlight.disable` is an upstream legacy nvim-treesitter
          # option. For Nixvim's native highlighting support with the modern nvim-treesitter main
          # branch, use `plugins.treesitter.highlight.disable` instead.
          enable = true; # enabled back again cause it's not highlighting everything
          # disable = [
          #   "latex"
          #   "markdown"
          # ];
        };
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        indent_enable = true;
        folding = true;
        autoLoad = true;
        incremental_selection.enable = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 4;
        min_window_height = 40;
      };
    };
    # tpope's indent fixes
    sleuth.enable = true;
  };
}
