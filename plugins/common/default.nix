# This is common neovim settings with basic plugin sets
{ config, lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
  # allowUnfree is handled at the flake pkgs level, not in nixvim module
  # nixpkgs.config.allowUnfree = true;
  luaLoader.enable = false;
  extraConfigLua = # lua
    ''
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true })
      vim.api.nvim_set_hl(0, "WhichKeyIcon", { link = "NONE", underline = false, undercurl = false })
      local function my_paste(reg)
        return function(lines)
          local content = vim.fn.getreg('"')
          return vim.split(content, '\n')
        end
      end
      if (os.getenv('SSH_TTY') ~= nil)
        then
          vim.g.clipboard = {
            name = 'OSC 52',
            copy = {
              ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
              ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
            },
            paste = {
              ["+"] = my_paste("+"),
              ["*"] = my_paste("*"),
            },
          }
        end



      vim.opt.whichwrap:append("<>[]hl")
      vim.opt.listchars:append("space:·")
    '';

  globals = {
    mapleader = config.nvix.leader; # sets <space> as my leader key
    floating_window_options.border = config.nvix.border;
  };

  opts = {

    clipboard = "unnamedplus";
    cursorline = true;
    cursorlineopt = "number";

    pumblend = 0;
    pumheight = 10;

    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    softtabstop = 2;

    ignorecase = true;
    smartcase = true;
    mouse = "a";
    cmdheight = 0;

    number = true;
    relativenumber = true;
    numberwidth = 2;
    ruler = false;

    signcolumn = "yes";
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";
    termguicolors = true;

    conceallevel = 2;

    undofile = true;

    wrap = false;

    virtualedit = "block";
    winminwidth = 5;
    fileencoding = "utf-8";
    list = true;
    smoothscroll = true;
    autoread = true;
    autowrite = true;
    swapfile = false;
    fillchars = {
      eob = " ";
    };

    updatetime = 500;
  };

  autoCmd = [
    {
      desc = "Highlight on yank";
      event = [ "TextYankPost" ];
      callback =
        # lua
        mkRaw ''
          function()
            vim.highlight.on_yank()
          end
        '';
    }
    {
      desc = "Reload files from disk when we focus vim";
      event = [ "FocusGained" ];
      pattern = [ "*" ];
      callback =
        # lua
        mkRaw ''
          function()
            if vim.fn.getcmdwintype() == "" then
              vim.cmd("checktime")
            end
          end
        '';
    }

    {
      desc = "Watch files for external changes using libuv";
      event = [
        "BufRead"
        "BufWritePost"
      ];
      pattern = [ "*" ];
      callback = mkRaw ''
        function(args)
          local bufnr = args.buf
          local filepath = vim.api.nvim_buf_get_name(bufnr)

          -- Only watch normal files
          if filepath == "" or vim.bo[bufnr].buftype ~= "" then
            return
          end

          -- Use a Lua table to store watchers (can't store userdata in vim.b)
          if not _G._nvix_watchers then
            _G._nvix_watchers = {}
          end

          -- Stop existing watcher for this buffer
          if _G._nvix_watchers[bufnr] then
            _G._nvix_watchers[bufnr]:stop()
            _G._nvix_watchers[bufnr] = nil
          end

          local uv = vim.uv or vim.loop
          local watcher = uv.new_fs_event()
          if not watcher then return end

          _G._nvix_watchers[bufnr] = watcher

          local function on_change(err, fname, status)
            if err then return end
            vim.schedule(function()
              -- Double-check buffer is still valid and unmodified
              if vim.api.nvim_buf_is_valid(bufnr) and not vim.bo[bufnr].modified then
                vim.api.nvim_buf_call(bufnr, function()
                  vim.cmd('checktime')
                end)
              end
            end)
          end

          -- Try watching the file directly
          pcall(function()
            watcher:start(filepath, {}, on_change)
          end)

          -- Cleanup when buffer is deleted
          vim.api.nvim_create_autocmd("BufDelete", {
            buffer = bufnr,
            once = true,
            callback = function()
              if _G._nvix_watchers[bufnr] then
                _G._nvix_watchers[bufnr]:stop()
                _G._nvix_watchers[bufnr] = nil
              end
            end
          })
        end
      '';
    }

    {
      desc = "Close the popup-menu automatically";
      event = [
        "CursorMovedI"
        "InsertLeave"
      ];
      pattern = [ "*" ];
      callback =
        # lua
        mkRaw ''
          function()
            if vim.fn.pumvisible() == 0
              and not vim.wo.pvw
              and vim.fn.getcmdwintype() == ""
            then
              vim.cmd("pclose")
            end
          end
        '';
    }
  ];

  performance.byteCompileLua = {
    enable = true;
    luaLib = true;
    nvimRuntime = true;
    plugins = true;
  };
}
