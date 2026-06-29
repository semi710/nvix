{ config, lib, ... }:
let
  inherit (config.nvix) icons;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.lualine.settings.sections = {
    lualine_a = [
      {
        __unkeyed = "fileformat";
        cond = null;
        padding = {
          left = 1;
          right = 1;
        };
        color = "SLGreen";
      }
    ];
    lualine_b = [ "encoding" ];
    lualine_c = [
      {
        __unkeyed = "b:gitsigns_head";
        icon = "${icons.git.Branch}";
        color.gui = "bold";
      }
      {
        __unkeyed = "diff";
        source =
          # lua
          mkRaw ''
            (function()
              local gitsigns = vim.b.gitsigns_status_dict
              if vim.b.gitsigns_status_dict then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end)
          '';
        symbols = {
          added = mkRaw ''"${icons.git.LineAdded}" .. " " '';
          modified = mkRaw ''"${icons.git.LineModified}".. " "'';
          removed = mkRaw ''"${icons.git.LineRemoved}".. " "'';
        };
      }
      {
        __unkeyed = "diagnostics";
        sources = {
          __unkeyed = "nvim_diagnostic";
        };
        symbols = {
          error = mkRaw ''"${icons.diagnostics.BoldError}" .. " "'';
          warn = mkRaw ''"${icons.diagnostics.BoldWarning}" .. " "'';
          info = mkRaw ''"${icons.diagnostics.BoldInformation}" .. " "'';
          hint = mkRaw ''"${icons.diagnostics.BoldHint}" .. " "'';
        };
      }
    ];
    lualine_x = [
      {
        color = {
          fg = "#ff9e64";
        };
        cond = mkRaw ''
          function()
            local ok, noice = pcall(require, "noice")
            if not ok then
              return false
            end
            return noice.api.status.mode.has()
          end
        '';
        __unkeyed =
          # lua
          mkRaw ''
            function()
              local ok, noice = pcall(require, "noice")
              if not ok then
                return false
              end
              return noice.api.status.mode.get()
            end
          '';
      }
      {
        __unkeyed =
          # lua
          mkRaw ''
            function()
              local clients = vim.lsp.get_clients()
              local names = {}
              for _, client in ipairs(clients) do
                if client.name ~= "copilot" and client.name ~= "null-ls" and client.name ~= "typos_lsp" then
                  names[#names + 1] = client.name:gsub("%[%d+%]", "")
                end
              end

              local ok, conform = pcall(require, "conform")
              if ok then
                local formatters = conform.list_formatters()
                for _, formatter in ipairs(formatters) do
                  if formatter.available and formatter.name ~= "squeeze_blanks" and formatter.name ~= "trim_whitespace" and formatter.name ~= "trim_newlines" then
                    names[#names + 1] = formatter.name
                  end
                end
              end

              local count = 0
              for _ in pairs(names) do count = count + 1 end
              if count == 0 then
                return "Ls Inactive"
              end
              return "[" .. table.concat(names, ", ") .. "]"
            end
          '';
      }

      {
        __unkeyed = "filetype";
        cond = null;
        padding = {
          left = 1;
          right = 1;
        };
      }
    ];
    lualine_y = [ "progress" ];
    lualine_z = [
      "location"
      {
        __unkeyed =
          # lua
          mkRaw ''
            function()
              local lsp_clients = vim.lsp.get_clients()
              for _, client in ipairs(lsp_clients) do
                if client.name == "copilot" then
                  return "%#SLGreen#" .. "${icons.kind.Copilot}"
                end
              end
               return ""
            end
          '';
      }
    ];
  };
}
