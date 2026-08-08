{ ... }:
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
      indent.enable = true;
      folding.enable = true;
      autoLoad = true;
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
