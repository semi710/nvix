{ config, lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
in
{

  wKeyList = [
    (wKeyObj [
      "<leader>lg"
      ""
      "goto"
    ])
    (wKeyObj [
      "<leader>l"
      ""
      "lsp"
    ])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>lO" (mkRaw ''
      function()
        local ok, otter = pcall(require, "otter")
        if not ok then return end
        local ok2, keeper = pcall(require, "otter.keeper")
        local bufnr = vim.api.nvim_get_current_buf()

        if ok2 and keeper.rafts[bufnr] then
          otter.deactivate()
          vim.notify("Otter deactivated")
        else
          otter.activate()
          if ok2 and keeper.rafts[bufnr] then
            vim.notify("Otter activated")
          end
        end
      end
    '') "Toggle Otter")
  ];

  plugins.lsp.keymaps.extra = [
    # Lspsaga

    (mkKeymap "n" "<leader>la" "<cmd>Lspsaga code_action<cr>" "Code Action")
    (mkKeymap "n" "<leader>lo" "<cmd>Lspsaga outline<cr>" "Outline")
    (mkKeymap "n" "<leader>lw" "<cmd>Lspsaga show_workspace_diagnostics<cr>" "Workspace Diagnostics")
    (mkKeymap "n" "gd" "<cmd>Lspsaga goto_definition<cr>" "Definitions")
    (mkKeymap "n" "<leader>lr" "<cmd>Lspsaga rename ++project<cr>" "Rename")
    (mkKeymap "n" "gt" "<cmd>Lspsaga goto_type_definition<cr>" "Type Definitions")
    (mkKeymap "n" "<leader>l." "<cmd>Lspsaga show_line_diagnostics<cr>" "Line Diagnostics")
    (mkKeymap "n" "gpd" "<cmd>Lspsaga peek_definition<cr>" "Peek Definition")
    (mkKeymap "n" "gpt" "<cmd>Lspsaga peek_type_definition<cr>" "Peek Type Definition")
    (mkKeymap "n" "[e" "<cmd>Lspsaga diagnostic_jump_prev<cr>" "Jump Prev Diagnostic")
    (mkKeymap "n" "]e" "<cmd>Lspsaga diagnostic_jump_next<cr>" "Jump Next Diagnostic")
    (mkKeymap "n" "K" (mkRaw ''
      function()
        local ok, ufo = pcall(require, "ufo")
        if ok then
          local winid = ufo.peekFoldedLinesUnderCursor()
        end
        if not winid then
          vim.cmd("Lspsaga hover_doc")
        end
      end
    '') "Hover Doc")

    # UFO
    (mkKeymap "n" "zR" (
      # lua
      mkRaw ''
        function()
          require("ufo").openAllFolds()
        end
      ''
    ) "Open all folds")
    (mkKeymap "n" "zM" (
      # lua
      mkRaw ''
        function()
          require("ufo").closeAllFolds()
        end
      ''
    ) "Close All Folds")
    (mkKeymap "n" "zK" (
      # lua
      mkRaw ''
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end
      ''
    ) "Peek Folded Lines")

    (mkKeymap "n" "<leader>lq" (mkRaw ''
      function()
        for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end
        vim.notify("LSP clients stopped")
      end
    '') "Stop LSP")
    (mkKeymap "n" "<leader>li" "<cmd>checkhealth vim.lsp<cr>" "LSP Info")
    (mkKeymap "n" "<leader>ls" (mkRaw ''
      function()
        vim.cmd('doautocmd FileType')
        vim.notify("LSP clients started")
      end
    '') "Start LSP")
    (mkKeymap "n" "<leader>lR" (mkRaw ''
      function()
        for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end
        vim.cmd('doautocmd FileType')
        vim.notify("LSP clients restarted")
      end
    '') "Restart LSP")

    (mkKeymap "n" "<C-s-k>" "<cmd>lua vim.lsp.buf.signature_help()<cr>" "Signature Help")
    (mkKeymap "n" "<leader>lD" "<cmd>lua Snacks.picker.lsp_definitions()<cr>" "Definitions list")
    (mkKeymap "n" "<leader>lS" "<cmd>lua Snacks.picker.lsp_symbols()<cr>" "Document Symbols")

    (mkKeymap "n" "<leader>lf" "<cmd>lua require('conform').format()<cr>" "Format file")
    (mkKeymap "x" "<leader>lf" "<cmd>lua require('conform').format()<cr>" "Format File")
    (mkKeymap "v" "<leader>lf" "<cmd>lua require('conform').format()<cr>" "Format File")

    (mkKeymap "n" "[d" "<cmd>lua vim.diagnostic.goto_prev()<cr>" "Previous Diagnostic")
    (mkKeymap "n" "]d" "<cmd>lua vim.diagnostic.goto_next()<cr>" "Next Diagnostic")
    (mkKeymap "n" "gr" "<cmd>Trouble lsp_references<cr>" "Trouble Lsp References")
    (mkKeymap "n" "<leader>lL" (
      # lua
      mkRaw ''
        function()
          if vim.g.diagnostics_visible == nil or vim.g.diagnostics_visible then
            vim.g.diagnostics_visible = false
            vim.diagnostic.disable()
          else
            vim.g.diagnostics_visible = true
            vim.diagnostic.enable()
          end
        end
      ''
    ) "Toggle Diagnostics")
    (mkKeymap "n" "<leader>ll" (
      # lua
      mkRaw ''
        function()
          if vim.diagnostic.config().virtual_text == false then
            vim.diagnostic.config({ virtual_text = { source = "always" } })
          else
            vim.diagnostic.config({ virtual_text = false })
          end
        end
      ''
    ) "Toggle Virtual Text")
  ];
}
