{ config, lib, ... }:
let
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
  inherit (lib.nixvim) mkRaw;
in
{
  wKeyList = [
    (wKeyObj [
      "<leader>."
      ""
      "Scratch Buffer"
    ])
    (wKeyObj [
      "<leader>:"
      ""
      ""
      true
    ])
    (wKeyObj [
      "<leader>s"
      ""
      "search"
    ])
    (wKeyObj [
      "<leader>f"
      ""
      "file/find"
    ])
    (wKeyObj [
      "<leader>e"
      "󰙅"
      "Explorer"
    ])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>.." "<cmd>:lua Snacks.scratch()<cr>" "Toggle Scratch Buffer")
    (mkKeymap "n" "<leader>.s" "<cmd>:lua Snacks.scratch.select()<cr>" "Select Scratch Buffer")
    (mkKeymap "n" "<leader>sn" "<cmd>:lua Snacks.notifier.show_history()<cr>" "Notification History")
    (mkKeymap "n" "<leader>.r" "<cmd>:lua Snacks.rename.rename_file()<cr>" "Rename file/variable +lsp")
    (mkKeymap "n" "<leader>un" "<cmd>:lua Snacks.notifier.hide()<cr>" "Dismiss All Notifications")

    (mkKeymap "n" "<leader>sb" "<cmd>:lua Snacks.picker.lines() <cr>" "Buffer Lines")
    (mkKeymap "n" "<leader>sB" "<cmd>:lua Snacks.picker.grep_buffers() <cr>" "Grep Open Buffers")
    (mkKeymap "n" "<leader>sg" "<cmd>:lua Snacks.picker.grep() <cr>" "Grep")
    (mkKeymap "n" "<leader>sw" "<cmd>:lua Snacks.picker.grep_word() <cr>" "Visual selection or word")
    (mkKeymap "x" "<leader>sw" "<cmd>:lua Snacks.picker.grep_word() <cr>" "Visual selection or word")
    (mkKeymap "n" ''<leader>s"'' "<cmd>:lua Snacks.picker.registers() <cr>" "Registers")
    (mkKeymap "n" "<leader>sa" "<cmd>:lua Snacks.picker.autocmds() <cr>" "Autocmds")
    (mkKeymap "n" "<leader>sb" "<cmd>:lua Snacks.picker.lines() <cr>" "Buffer Lines")
    (mkKeymap "n" "<leader>sc" "<cmd>:lua Snacks.picker.command_history() <cr>" "Command History")
    (mkKeymap "n" "<leader>sC" "<cmd>:lua Snacks.picker.commands() <cr>" "Commands")
    (mkKeymap "n" "<leader>sd" "<cmd>:lua Snacks.picker.diagnostics() <cr>" "Diagnostics")
    (mkKeymap "n" "<leader>sD" "<cmd>:lua Snacks.picker.diagnostics_buffer() <cr>" "Buffer Diagnostics")
    (mkKeymap "n" "<leader>sH" "<cmd>:lua Snacks.picker.highlights() <cr>" "Highlights")
    (mkKeymap "n" "<leader>si" "<cmd>:lua Snacks.picker.icons() <cr>" "Icons")
    (mkKeymap "n" "<leader>sj" "<cmd>:lua Snacks.picker.jumps() <cr>" "Jumps")
    (mkKeymap "n" "<leader>sl" "<cmd>:lua Snacks.picker.loclist() <cr>" "Location List")
    (mkKeymap "n" "<leader>sm" "<cmd>:lua Snacks.picker.marks() <cr>" "Marks")
    (mkKeymap "n" "<leader>sM" "<cmd>:lua Snacks.picker.man() <cr>" "Man Pages")
    (mkKeymap "n" "<leader>sq" "<cmd>:lua Snacks.picker.qflist() <cr>" "Quickfix List")
    (mkKeymap "n" "<leader>sR" "<cmd>:lua Snacks.picker.resume() <cr>" "Resume")
    (mkKeymap "n" "<leader>su" "<cmd>:lua Snacks.picker.undo() <cr>" "Undo History")

    (mkKeymap "n" "gd" "<cmd>:lua Snacks.picker.lsp_definitions() <cr>" "Goto Definition")
    (mkKeymap "n" "gD" "<cmd>:lua Snacks.picker.lsp_declarations() <cr>" "Goto Declaration")
    (mkKeymap "n" "gr" "<cmd>:lua Snacks.picker.lsp_references() <cr>" "References")
    (mkKeymap "n" "gI" "<cmd>:lua Snacks.picker.lsp_implementations() <cr>" "Goto Implementation")
    (mkKeymap "n" "gy" "<cmd>:lua Snacks.picker.lsp_type_definitions() <cr>" "Goto T[y]pe Definition")
    (mkKeymap "n" "<leader>ss" "<cmd>:lua Snacks.picker.lsp_symbols() <cr>" "LSP Symbols")
    (mkKeymap "n" "<leader>sS" "<cmd>:lua Snacks.picker.lsp_workspace_symbols() <cr>"
      "LSP Workspace Symbols"
    )

    # Telescope replacement
    (mkKeymap "n" "<leader>sP" "<cmd>:lua Snacks.picker({layout = 'vscode'})<cr>" "Pickers")
    (mkKeymap "n" "<leader>ss" "<cmd>:lua Snacks.picker.smart()<cr>" "Smart")
    (mkKeymap "n" "<leader>st" "<cmd>:lua Snacks.picker.todo_comments()<cr>" "Todo")
    (mkKeymap "n" "<leader>sT"
      ''<cmd>:lua Snacks.picker.todo_comments({keywords = {"TODO", "FIX", "FIXME"})<cr>''
      "Todo"
    )
    (mkKeymap "n" "<leader>s:" "<cmd>:lua Snacks.picker.command_history()<cr>" "Command History")
    (mkKeymap "n" "<leader>s," "<cmd>:lua Snacks.picker.buffers()<cr>" "Buffers")
    (mkKeymap "n" "<leader>sh" "<cmd>:lua Snacks.picker.help()<cr>" "Help Pages")
    (mkKeymap "n" "<leader>sk" "<cmd>:lua Snacks.picker.keymaps({layout = 'vscode'})<cr>" "Keymaps")

    (mkKeymap "n" "<leader>su" (
      # lua
      mkRaw ''
        function()
          Snacks.picker.undo({
            win = {
              input = {
                keys = {
                  ["y"] = { "yank_add", mode =  "n" },
                  ["Y"] = { "yank_del", mode =  "n" },
                },
              },
            },
          })
        end
      ''
    ) "Undo")

    (mkKeymap "n" "<leader>ff" "<cmd>:lua Snacks.picker.files()<cr>" "Find Files")
    (mkKeymap "n" "<leader>fF" "<cmd>:lua Snacks.picker.smart()<cr>" "Smart")
    (mkKeymap "n" "<leader>f/"
      "<cmd>:lua Snacks.picker.grep({ title = 'Grep | pat -- -t ft | -g glob | a-r | a-h | a-i' })<cr>"
      "Grep"
    )
    (mkKeymap "n" "<leader>fr" "<cmd>:lua Snacks.picker.recent()<cr>" "Recent")
    (mkKeymap "n" "<leader>fp" "<cmd>:lua Snacks.picker.projects()<cr>" "Projects")
  ];
}
