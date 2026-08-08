{
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
in
{
  extraConfigLua = # lua
    ''
      vim.cmd([[
        function! MkdpNoOp(url)
        endfunction
      ]])
    '';

  plugins = {
    lsp.servers.marksman.enable = true;
    img-clip.enable = true;
    markdown-preview = {
      enable = true;
      settings.echo_preview_url = 1;
      settings.open_to_the_world = 1;
      settings.browserfunc = "MkdpNoOp";
    };
    render-markdown = {
      enable = true;
      settings = {
        checkbox = {
          unchecked.icon = "";
          checked.icon = "";
          custom = {
            todo = {
              raw = "[-]";
              rendered = "󰥕 ";
              highlight = "RenderMarkdownTodo";
            };
          };
        };
        # Don't conceal [[...]] when contents look like a LeetCode-style
        # numeric/array literal (e.g. [[1,2]], [["a","b"]]). Real wiki-links
        # such as [[My Note]] still render normally.
        link.wiki.body =
          # lua
          mkRaw ''
            function(ctx)
              local text = (ctx and ctx.text) or ""
              if text:match("^[%d%s,%-%[%]%.\"']+$") then
                return false
              end
              return nil
            end
          '';
      };
    };
    mkdnflow = {
      enable = true;
      settings = {
        modules.bib = false;
        create_dirs = true;
        to_do = {
          statuses = {
            not_started.marker = " ";
            in_progress.marker = "-";
            complete.marker = "x";
          };
        };
        links = {
          style = "markdown";
          transform_on_create =
            # lua
            mkRaw ''
              function(text)
                text = text:gsub("[ /]", "-")
                text = text:lower()
                return text
              end
            '';
        };
        mappings = {
          # normal: paste clipboard as [clipboard](clipboard)
          # visual: [selection](clipboard) (selection=display, clipboard=target)
          MkdnCreateLinkFromClipboard = [
            [
              "n"
              "v"
            ]
            "<leader>mc"
          ];
          # cursor on a [link](path): move/rename its target file + update all refs
          MkdnMoveSource = [
            "n"
            "<leader>mm"
          ];
          # yank links to clipboard (cursor must be on a heading)
          MkdnYankAnchorLink = [
            "n"
            "<leader>ma"
          ];
          MkdnYankFileAnchorLink = [
            "n"
            "<leader>mf"
          ];
        };
      };
    };
    glow = {
      enable = true;
      lazyLoad.settings = {
        ft = [ "markdown" ];
        cmd = [ "Glow" ];
      };
    };
  };

  autoCmd = [
    {
      desc = "Setup Markdown mappings";
      event = [
        "FileType"
        "BufEnter"
      ];
      pattern = "*";
      callback =
        # lua
        mkRaw ''
          function(args)
            if vim.bo[args.buf].filetype ~= "markdown" then return end
            if vim.b[args.buf]._nvix_md_keys then return end
            vim.b[args.buf]._nvix_md_keys = true
            local buf = args.buf

            local function on_markdown_image()
              local col = vim.api.nvim_win_get_cursor(0)[2] + 1
              local line = vim.api.nvim_get_current_line()
              local pos = 1
              while pos <= #line do
                local s, e = line:find("!%[[^%]]*%]%([^%)]*%)", pos)
                if not s then return false end
                if col >= s and col <= e then return true end
                pos = e + 1
              end
              return false
            end

            local function show_image_or_hover()
              if on_markdown_image() then
                Snacks.image.hover()
                return
              end

              local ok, ufo = pcall(require, "ufo")
              local winid = ok and ufo.peekFoldedLinesUnderCursor()
              if not winid then
                vim.cmd("Lspsaga hover_doc")
              end
            end

            vim.keymap.set('n', 'K', show_image_or_hover,
              { buffer = buf, desc = "Markdown image or hover doc", noremap = true, silent = true })

            vim.api.nvim_create_autocmd('CursorHold', {
              buffer = buf,
              callback = function()
                if on_markdown_image() then Snacks.image.hover() end
              end,
              desc = "Preview markdown image under cursor",
            })

            -- <leader>pg  Glow (terminal) preview
            vim.keymap.set('n', '<leader>pg', '<cmd>Glow<CR>',
              { buffer = buf, desc = "Markdown Glow preview", silent = true })

            -- <leader>pb  Browser preview + copy localhost URL to clipboard
            vim.keymap.set('n', '<leader>pb', function()
              vim.cmd('MarkdownPreview')
              vim.defer_fn(function()
                local msgs = vim.api.nvim_exec2('messages', { output = true }).output
                local url = nil
                for line in msgs:gmatch("[^\n]+") do
                  local m = line:match("https?://[%d%.]+:%d+/%S*") or line:match("https?://[%d%.]+:%d+")
                  if m then url = m end
                end
                if url then
                  url = url:gsub("https?://[%d%.]+", "http://localhost")
                  vim.fn.setreg('+', url)
                  vim.notify("URL copied to clipboard: " .. url, vim.log.levels.INFO)
                end
              end, 500)
            end, { buffer = buf, desc = "Markdown Browser Preview + Copy URL", noremap = true, silent = true })

            -- gd: follow markdown link under cursor, else fall back to LSP definition
            vim.keymap.set('n', 'gd', function()
              local col = vim.api.nvim_win_get_cursor(0)[2] + 1
              local line = vim.api.nvim_get_current_line()
              local pos = 1
              while pos <= #line do
                local s, e = line:find("%[[^%]]*%]%([^%)]*%)", pos)
                if not s then break end
                if col >= s and col <= e then
                  vim.cmd("MkdnFollowLink")
                  return
                end
                pos = e + 1
              end
              vim.cmd("Trouble lsp_definitions")
            end, { buffer = buf, desc = "Follow link or LSP definition", noremap = true, silent = true })

            -- <leader>mr  Rename link display text (keep target file)
            vim.keymap.set('n', '<leader>mr', function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              local line = vim.api.nvim_get_current_line()
              local pos = 1
              while pos <= #line do
                local s, e = line:find("%[[^%]]*%]%([^%)]*%)", pos)
                if not s then break end
                if col + 1 >= s and col + 1 <= e then
                  local close_bracket = line:find("%]", s + 1)
                  local current_display = line:sub(s + 1, close_bracket - 1)
                  local target = line:sub(close_bracket + 2, e - 1)
                  local before = line:sub(1, s - 1)
                  local after = line:sub(e + 1)
                  vim.ui.input({ prompt = "Display name: ", default = current_display }, function(input)
                    if input then
                      vim.api.nvim_set_current_line(before .. "[" .. input .. "](" .. target .. ")" .. after)
                    end
                  end)
                  return
                end
                pos = e + 1
              end
              vim.notify("Not on a markdown link", vim.log.levels.WARN)
            end, { buffer = buf, desc = "Rename display (keep file)", noremap = true, silent = true })

            -- <leader>mo  List outgoing links
            vim.keymap.set('n', '<leader>mo', function()
              local dir = vim.fn.expand("%:p:h")
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
              local items = {}
              for lnum, line in ipairs(lines) do
                local pos = 1
                while pos <= #line do
                  local s, e = line:find("%[[^%]]*%]%([^%)]*%)", pos)
                  if not s then break end
                  local close_bracket = line:find("%]", s + 1)
                  local display = line:sub(s + 1, close_bracket - 1)
                  local target = line:sub(close_bracket + 2, e - 1)
                  table.insert(items, {
                    text = display,
                    file = vim.fn.simplify(dir .. "/" .. target),
                    line = lnum,
                    col = s,
                  })
                  pos = e + 1
                end
              end
              if #items == 0 then
                vim.notify("No outgoing links in this file", vim.log.levels.INFO)
                return
              end
              Snacks.picker.pick({
                title = "Outgoing Links",
                items = items,
                format = function(item)
                  return { { item.text, "SnacksPickerLabel" }, { "  " .. item.file, "SnacksPickerComment" } }
                end,
                confirm = function(picker, item)
                  picker:close()
                  vim.cmd("e " .. vim.fn.fnameescape(item.file))
                end,
              })
            end, { buffer = buf, desc = "List outgoing links", noremap = true, silent = true })

            -- <leader>mb  List backlinks
            vim.keymap.set('n', '<leader>mb', function()
              local name = vim.fn.expand("%:t:r")
              local dir = vim.fn.expand("%:p:h")
              Snacks.picker.grep({
                cwd = dir,
                search = name,
                title = "Backlinks to " .. name,
              })
            end, { buffer = buf, desc = "List backlinks", noremap = true, silent = true })

            -- which-key groups for markdown-only
            local ok, wk = pcall(require, "which-key")
            if ok then
              wk.add({
                { "<leader>p", group = "preview", icon = "󰋭", buffer = buf },
                { "<leader>m", group = "mkdnflow", icon = "󰫌", buffer = buf },
                { "<leader>n", group = "numbering", icon = "󰲔", buffer = buf },
              })
            end
          end
        '';
    }
  ];
}
