{ lib, config, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) mkKeymap;
in
{
  plugins.snacks.settings = {
    styles.lazygit = {
      width = 0;
      height = 0;
    };
    lazygit.config.os = {
      edit = mkRaw ''
        '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})'
      '';
      editAtLine = mkRaw ''
        '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")'
      '';
      openDirInEditor = mkRaw ''
        '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})'
      '';
      openInTerminal = mkRaw ''
        '[ -z "$NVIM" ]'
      '';
    };
  };
  keymaps = [
    (mkKeymap "n" "<leader>gB" "<cmd>lua Snacks.gitbrowse()<cr>" "Git Browse")
    (mkKeymap "n" "<leader>gf" "<cmd>lua Snacks.lazygit.log_file()<cr>" "Lazygit Current File History")
    (mkKeymap "n" "<leader>gg" "<cmd>lua Snacks.lazygit()<cr>" "Lazygit")
    (mkKeymap "n" "<leader>gl" "<cmd>:lua Snacks.lazygit.log()<cr>" "Lazygit Log (cwd)")
    (mkKeymap "n" "<leader>gL" "<cmd>:lua Snacks.picker.git_log()<cr>" "Git Log (cwd)")
  ];
}
