{
  plugins.noice = {
    enable = true;
    settings = {
      presets.bottom_search = true;
      routes = [
        # FIXME: <https://github.com/folke/noice.nvim/issues/1097>
        {
          filter = {
            event = "msg_show";
            kind = [ "shell_out" ];
          };
          view = "notify";
          opts = {
            level = "info";
            title = "stdout";
          };
        }
        {
          filter = {
            event = "msg_show";
            kind = [ "shell_err" ];
          };
          view = "notify";
          opts = {
            level = "error";
            title = "stderr";
          };
        }
      ];
      views = {
        cmdline_popup = {
          position = {
            row = -2;
            col = "50%";
          };
          border.style = "none";
        };
        cmdline_popupmenu.position = {
          row = -5;
          col = "50%";
        };
      };

      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        hover.enabled = false;
        message.enabled = false;
        signature.enabled = false;
        progress.enabled = false;
      };
    };
  };
}
