{ lib, pkgs, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.leetcode = {
    enable = true;
    # Heavy plugin only used on demand via :Leet.
    lazyLoad.settings.cmd = [ "Leet" ];
    settings.lang = "python3";
    package = pkgs.vimPlugins.leetcode-nvim.overrideAttrs (oa: {
      src = pkgs.fetchFromGitHub {
        owner = "niksingh710";
        repo = "leetcode.nvim";
        rev = "cab77da208b0abca7070ef4213bc4cea1a339ada";
        hash = "sha256-Uf+66Z+S0o0G+JZR++mAhKX+gTN9NJY0WkVr0dfRlWw=";
      };
    });
  };

  # Skip render-markdown for leetcode.nvim managed buffers/files.
  plugins.render-markdown.settings.ignore =
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
}
