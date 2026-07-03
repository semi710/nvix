{ config, lib, ... }:
let
  inherit (config.nvix.mkKey) mkKeymap mkKeymapWithOpts wKeyObj;
  inherit (lib.nixvim) mkRaw;
  # Set of General mappings not dependent on any plugins
  v = [

    (mkKeymap "v" "<c-s>" "<esc>:w<cr>" "Saving File")
    (mkKeymap "v" "<c-c>" "<esc>" "Escape")

    (mkKeymap "v" "<a-j>" ":m '>+1<cr>gv-gv" "Move Selected Line Down")
    (mkKeymap "v" "<a-k>" ":m '<lt>-2<CR>gv-gv" "Move Selected Line Up")

    (mkKeymap "v" "<" "<gv" "Indent out")
    (mkKeymap "v" ">" ">gv" "Indent in")

    (mkKeymap "v" "<space>" "<Nop>" "Mapped to Nothing")
  ];

  xv = [
    (mkKeymapWithOpts "x" "j" ''v:count || mode(1)[0:1] == "no" ? "j" : "gj"'' "Move down" {
      expr = true;
    })
    (mkKeymapWithOpts "x" "k" ''v:count || mode(1)[0:1] == "no" ? "k" : "gk"'' "Move up" {
      expr = true;
    })
  ];

  insert = [
    (mkKeymap "i" "jk" "<esc>" "Normal Mode")
    (mkKeymap "i" "<c-s>" "<esc>:w ++p<cr>" "Save file")
    (mkKeymap "i" "<a-j>" "<esc>:m .+1<cr>==gi" "Move Line Down")
    (mkKeymap "i" "<a-k>" "<esc>:m .-2<cr>==gi" "Move Line Up")
  ];

  normal = [
    (mkKeymap "n" "<c-a-h>" ":lua require('smart-splits').resize_left()<cr>" "Resize Left")
    (mkKeymap "n" "<c-a-j>" ":lua require('smart-splits').resize_down()<cr>" "Resize Down")
    (mkKeymap "n" "<c-a-k>" ":lua require('smart-splits').resize_up()<cr>" "Resize Up")
    (mkKeymap "n" "<c-a-l>" ":lua require('smart-splits').resize_right()<cr>" "Resize Right")
    (mkKeymap "n" "?" (
      # lua
      mkRaw ''
        function()
          require('flash').jump({
            forward = true, wrap = true, multi_window = true
          })
          end
      ''
    ) "Flash Search")

    (mkKeymap "n" "<c-h>" ":lua require('smart-splits').move_cursor_left()<cr>" "Move Cursor Left")
    (mkKeymap "n" "<c-j>" ":lua require('smart-splits').move_cursor_down()<cr>" "Move Cursor Down")
    (mkKeymap "n" "<c-k>" ":lua require('smart-splits').move_cursor_up()<cr>" "Move Cursor Up")
    (mkKeymap "n" "<c-l>" ":lua require('smart-splits').move_cursor_right()<cr>" "Move Cursor Right")
    (mkKeymap "n" "<c-\\>" ":lua require('smart-splits').move_cursor_previous()<cr>"
      "Move Cursor Previous"
    )
    (mkKeymap "n" "<leader>dd"
      (
        # lua
        mkRaw ''
          function()
            local any_diff = false
            for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_get_option(w, "diff") then
                any_diff = true
                break
              end
            end

            if any_diff then
              vim.cmd("windo diffoff")
            else
              vim.cmd("windo diffthis")
            end
          end
        ''
      )

      "Toggle Diff the opened windows"
    )

    (mkKeymap "n" "<c-s>" "<cmd>w ++p<cr>" "Save the file")
    (mkKeymap "n" "<a-+>" "<C-a>" "Increase Number")
    (mkKeymap "n" "<a-->" "<C-x>" "Decrease Number")

    (mkKeymap "n" "<a-j>" "<cmd>m .+1<cr>==" "Move line Down")
    (mkKeymap "n" "<a-k>" "<cmd>m .-2<cr>==" "Move line up")

    (mkKeymap "n" "<leader>qq" "<cmd>quitall!<cr>" "Quit!")
    (mkKeymap "n" "<leader>qw" (
      # lua
      mkRaw ''
        function()
          local wins = vim.api.nvim_tabpage_list_wins(0)
          if #wins > 1 then
              local ok, err = pcall(vim.cmd, 'close')
              if not ok then
                  vim.notify("Cannot close the last window!", vim.log.levels.WARN)
              end
          else
              vim.notify("Cannot close the last window!", vim.log.levels.WARN)
          end
        end
      ''
    ) "Close Window!")

    (mkKeymap "n" "<leader><leader>" "<cmd>nohl<cr>" "no highlight!")
    (mkKeymap "n" "<esc>" "<esc>:nohlsearch<cr>" "escape")
    (mkKeymap "n" "<leader>A" "ggVG" "select All")

    (mkKeymap "n" "<leader>|" "<cmd>vsplit<cr>" "vertical split")
    (mkKeymap "n" "<leader>-" "<cmd>split<cr>" "horizontal split")

    # quickfix
    (mkKeymap "n" "<leader>cn" "<cmd>cnext<cr>" "quickfix next")
    (mkKeymap "n" "<leader>cp" "<cmd>cprev<cr>" "quickfix prev")
    (mkKeymap "n" "<leader>cq" "<cmd>cclose<cr>" "quit quickfix")

    (mkKeymap "n" "<leader>id" (
      # lua
      mkRaw ''
        function()
          local date = "# " .. os.date("%d-%m-%y")
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_get_current_line()

          -- Insert date at cursor position
          local new_line = line:sub(1, col) .. date .. line:sub(col + 1)
          vim.api.nvim_set_current_line(new_line)

          -- Move cursor to next line
          vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        end
      ''
    ) "Insert Date at cursor position")

    (mkKeymap "n" "n" "nzzzv" "Move to center")
    (mkKeymap "n" "N" "Nzzzv" "Moving to center")
    (mkKeymap "n" "<leader>uC" (
      # lua
      mkRaw ''
        require('stay-centered').toggle
      ''
    ) "Toggle stay-centered.nvim")
    (mkKeymap "n" "<leader>ft" (
      # lua
      mkRaw ''
        function()
          vim.ui.input({ prompt = "Enter FileType: " }, function(input)
            local ft = input
            if not input or input == "" then
              ft = vim.bo.filetype
            end
            vim.o.filetype = ft
          end)
        end
      ''
    ) "Set Filetype")

    (mkKeymapWithOpts "n" "j" ''v:count || mode(1)[0:1] == "no" ? "j" : "gj"'' "Move down" {
      expr = true;
    })
    (mkKeymapWithOpts "n" "k" ''v:count || mode(1)[0:1] == "no" ? "k" : "gk"'' "Move up" {
      expr = true;
    })

  ];
in
{
  keymaps = insert ++ normal ++ v ++ xv;

  # This is list to present icon on which key
  wKeyList = [
    (wKeyObj [
      "<leader>A"
      ""
      ""
      "true"
    ])
    (wKeyObj [
      "<leader><leader>"
      ""
      ""
      "true"
    ])
    (wKeyObj [
      "<leader>q"
      ""
      "quit/session"
    ])
    (wKeyObj [
      "<leader>i"
      ""
      "Insert"
    ])
    (wKeyObj [
      "<leader>v"
      "󰩬"
      "Insert"
    ])
    (wKeyObj [
      "z"
      "󰘁"
      "fold"
    ])
    (wKeyObj [
      "g"
      "󰿘"
      "goto"
    ])
    (wKeyObj [
      "["
      "󰒲"
      "next"
    ])
    (wKeyObj [
      "]"
      "󰒱"
      "prev"
    ])
    (wKeyObj [
      "<leader>u"
      "󰔎"
      "ui"
    ])
    (wKeyObj [
      "<leader>o"
      ""
      "Open"
    ])
    (wKeyObj [
      "<leader>d"
      ""
      "diff"
    ])
    (wKeyObj [
      "<leader>|"
      ""
      "vsplit"
    ])
    (wKeyObj [
      "<leader>-"
      ""
      "split"
    ])
    (wKeyObj [
      "<leader>c"
      "󰁨"
      "quickfix"
    ])
  ];

  extraConfigLua = # lua
    ''

      -- Use black hole register for 'x', 'X', 'c', 'C'
      vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'X', '"_X', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'c', '"_c', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'C', '"_C', { noremap = true, silent = true })

      -- Visual mode
      vim.api.nvim_set_keymap('v', 'x', '"_d', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', 'X', '"_d', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', 'c', '"_c', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', 'C', '"_c', { noremap = true, silent = true })

      -- In visual mode, paste from the clipboard without overwriting it
      vim.api.nvim_set_keymap("v", "p", '"_dP', { noremap = true, silent = true })

      -- Only this hack works in command mode
      vim.cmd([[
        cnoremap <C-j> <C-n>
        cnoremap <C-k> <C-p>
      ]])
    '';
}
