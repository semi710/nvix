{ ... }:
{
  flake.overlays.default = (
    final: prev: {
      # Fix hardcoded WASM path in kulala-core bundled JS.
      # Upstream bundles __filename as the Nix build directory, which doesn't
      # exist at runtime. Patch it so liblua5.1.wasm resolves relative to the
      # installed location instead.
      # TODO: Remove once fixed upstream in nixpkgs.
      kulala-core = prev.kulala-core.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/lib/kulala-core/kulala-core.js \
            --replace \
              '/build/source/node_modules/wasmoon-lua5.1/dist/index.js' \
              "$out/lib/kulala-core/kulala-core.js"
        '';
      });
    }
  );
}
