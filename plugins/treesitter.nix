{ pkgs, ... }:
{
  plugins = {
    mini-ai.enable = true;
    treesitter = {
      enable = true;
      highlight = {
        enable = true;
        # Vimtex provides syntax highlighting for latex; tree-sitter clashes with it
        disable = [ "latex" ];
      };
      settings = {
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
