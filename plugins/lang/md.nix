{
  config,
  lib,
  ...
}:
let
  inherit (config.nvix.mkKey) wKeyObj mkKeymap;
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
    lsp.servers = {
      markdown_oxide.enable = true;
      marksman.enable = true;
    };
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
        # Skip render-markdown entirely for leetcode.nvim managed buffers/files.
        ignore =
          # lua
          mkRaw ''
            function(bufnr)
              bufnr = bufnr or 0
              local name = vim.api.nvim_buf_get_name(bufnr)
              -- leetcode.nvim stores solution files under stdpath('data')/leetcode/
              if name:match("/leetcode/") then
                return true
              end
              -- also skip its custom filetype if ever set
              if vim.bo[bufnr].filetype == "leetcode.nvim" then
                return true
              end
              return false
            end
          '';
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
    obsidian = {
      enable = true;
      settings = {
        legacy_commands = false;
        ui.enable = false;
        footer.enabled = false;
        link.style = "markdown";
        note_id_func =
          # lua
          mkRaw ''
            function(title)
              return title
            end
          '';
        note_path_func =
          # lua
          mkRaw ''
            function(spec)
              local raw = spec.id or spec.title or tostring(os.time())

              -- normalize once, centrally
              local normalized = raw
                :gsub("\\", "/")
                :gsub("^%./", "")                  -- remove leading ./
                :gsub("%s+", "-")
                :gsub("[^A-Za-z0-9%-%./]", "")
                :lower()

              local parts = vim.split(normalized, "/")
              local filename = parts[#parts]
              table.remove(parts, #parts)

              local dir = spec.dir
              for _, p in ipairs(parts) do
                dir = dir / p
              end

              return (dir / filename):with_suffix(".md")
            end
          '';
        templates = {
          folder = ".notes/templates";
        };
        workspaces = [
          {
            name = "Notes";
            # Use a function so the directory is created on first run if missing.
            # obsidian.nvim's Workspace.new requires `path` to exist; otherwise it
            # silently drops the spec and setup errors with "At least one workspace
            # is required!" -- bad UX for first-time users.
            path =
              # lua
              mkRaw ''
                function()
                  local p = vim.fn.expand("~/.notes")
                  vim.fn.mkdir(p, "p")
                  return p
                end
              '';
          }
        ];
      };
    };
    glow = {
      enable = true;
      lazyLoad.settings = {
        ft = "markdown";
        cmd = "Glow";
      };
    };
  };

  autoCmd = [
    {
      desc = "Setup Markdown mappings";
      event = "Filetype";
      pattern = "markdown";
      callback =
        # lua
        mkRaw ''
          function()
            -- <leader>pg  Glow (terminal) preview
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pg', '<cmd>Glow<CR>',
              { desc = "Markdown Glow preview", noremap = true, silent = true })

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
            end, { buffer = 0, desc = "Markdown Browser Preview + Copy URL", noremap = true, silent = true })

            -- <leader>pp  Print to PDF via pandoc
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pp', '<cmd>lua require("md-pdf").convert_md_to_pdf()<CR>',
              { desc = "Markdown Print pdf", noremap = true, silent = true })
          end
        '';
    }
  ];

  keymaps = [
    (mkKeymap "n" "<leader>os" "<cmd>Obsidian quick_switch<cr>" "Obsidian Quick Switch")
    (mkKeymap "n" "<leader>o/" "<cmd>Obsidian search<cr>" "Obsidian Switch")
    (mkKeymap "n" "<leader>ot" "<cmd>Obsidian tags<cr>" "Obsidian tag search")
    (mkKeymap "n" "<leader>ol" "<cmd>Obsidian links<cr>" "Obsidian Buffer links")
    (mkKeymap "n" "<leader>or" "<cmd>Obsidian backlinks<cr>" "Who links Current Buffer")
    (mkKeymap "n" "<leader>o|" "<cmd>Obsidian follow_link vsplit<cr>"
      "Open the link in a vertical split"
    )
    (mkKeymap "n" "<leader>o-" "<cmd>Obsidian follow_link hsplit<cr>"
      "Open the link in a horizontal split"
    )
    (mkKeymap "n" "<leader>o<cr>" (
      # lua
      mkRaw ''
        function ()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_get_current_line()

          -- match word including / and -
          local pattern = "[A-Za-z0-9_/%-]+"

          local start_col, end_col

          for s, e in function() return string.find(line, pattern, (start_col or 1)) end do
            if col + 1 >= s and col + 1 <= e then
              start_col = s
              end_col = e
              break
            end
            start_col = e + 1
          end

          if not start_col then
            return
          end

          -- enter visual mode and select range
          vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
          vim.cmd("normal! v")
          vim.api.nvim_win_set_cursor(0, { row, end_col })

          -- run command (expects visual selection)
          vim.cmd("Obsidian link_new")
        end
      ''
    ) "Make note from text under cursor")
  ];
  wKeyList = [
    (wKeyObj [
      "<leader>p"
      ""
      "preview"
    ])
    (wKeyObj [
      "<leader>o"
      ""
      "Obsidian"
    ])
  ];
}
