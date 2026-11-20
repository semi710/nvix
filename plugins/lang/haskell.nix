{
  lib,
  ...
}:
{
  plugins.lsp.servers.hls = {
    enable = true;
    # legacy alias for ghc.enable: keeps nixvim from installing ghc AND
    # dismisses its "hls relies on ghc" eval warning
    installGhc = false;
    # HLS + GHC add ~9 GB to the closure, and a global HLS pinned to one GHC
    # is wrong for projects on other versions anyway - let lspconfig resolve
    # haskell-language-server from $PATH (project devshells).
    package = lib.mkForce null;
  };
}
