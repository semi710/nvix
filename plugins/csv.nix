{ config, lib, ... }:
let
  inherit (config.nvix.mkKey) mkKeymap;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.csvview.enable = true;
  # default keymaps are empty; enable the plugin's own Excel-like motions
  plugins.csvview.settings.keymaps = mkRaw ''
    {
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
    }
  '';

  keymaps = [
    (mkKeymap "n" "<leader>uV" "<cmd>CsvViewToggle<cr>" "Toggle CSV view")
  ];

  # csv files open in the aligned/colored view; uV toggles it off
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [ "csv" ];
      callback =
        # lua
        mkRaw ''
          function()
            vim.cmd("CsvViewEnable")
          end
        '';
    }
  ];
}
