{ pkgs, ... }:
{
  plugins = {
    rustaceanvim = {
      enable = true;
      # Upstream's busted LSP suite races 10s timeouts against a real
      # rust-analyzer and flakes in cold sandboxed CI runners.
      package = pkgs.vimPlugins.rustaceanvim.overrideAttrs (_: {
        doCheck = false;
      });
    };
    crates.enable = true;
  };
}
