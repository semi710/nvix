{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
in
{
  # Generalise for all colorschemes
  # <https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12266647>

  # TODO: <https://github.com/folke/snacks.nvim/discussions/2003#discussioncomment-13653042>
  # Implement this with a fix, i have done the implementation in nix way, but `grep` seems to break.
  # first check is required if it is from lua or nix
  plugins.todo-comments.enable = true;
  plugins.neoscroll.enable = true;
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      scroll.enabled = false;
      animate.enabled = true;
      quickfile.enabled = true;
      indent.enabled = true;
      words.enabled = true;
      statuscolumn.enabled = true;
      image = {
        enabled = true;
        force = true;
        doc = {
          enabled = true;
          float = true;
          inline = true;
          max_height = 40;
          max_width = 80;
        };
      };
      styles.snacks_image = {
        border = "none";
      };
      notifier = {
        enabled = true;
        style = "minimal";
        top_down = false;
      };
    };
  };

  extraPackages = with pkgs; [
    imagemagick
    ghostscript_headless
    mermaid-cli
    dwt1-shell-color-scripts
  ]; # for image support

  autoCmd = [
    {
      desc = "Pre init Function";
      event = [ "VimEnter" ];
      callback =
        # lua
        mkRaw ''
          -- Taken from https://github.com/folke/snacks.nvim?tab=readme-ov-file#-usage
          function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
          Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("spell",
          { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap",
          { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber",
          { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.option("conceallevel",
          { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.option("background",
          { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          end
        '';
    }
  ];

  imports = inputs.nix-wire.lib.autoImport ./.;
}
