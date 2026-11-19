{ ... }:
{
  flake.overlays.default = (
    final: prev: {
      # Fix hardcoded WASM path in kulala-core bundled JS.
      # Bun bakes each bundled CJS module's __filename as an absolute path
      # anchored at the build source root, which doesn't exist at runtime.
      # Wasmoon resolves liblua5.1.wasm relative to that path, so point it at
      # the installed location instead. postInstall runs in the same shell
      # and cwd as buildPhase, so $PWD matches the baked prefix regardless of
      # platform sandbox layout. --replace-fail makes drift loud instead of
      # silently shipping a broken bundle.
      # TODO: Remove once fixed upstream in nixpkgs.
      kulala-core = prev.kulala-core.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/lib/kulala-core/kulala-core.js \
            --replace-fail "$PWD/node_modules/wasmoon-lua5.1/dist/index.js" \
              "$out/lib/kulala-core/kulala-core.js"
        '';
      });
    }
  );
}
