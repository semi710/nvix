{ lib, ... }:
{
  nvix.mkKey = rec {
    # set of functions that returns attrs for keymap List
    mkKeymap = mode: key: action: desc: {
      inherit mode key action;
      options = {
        inherit desc;
        silent = true;
        noremap = true;
        remap = true;
      };
    };

    # Use when custom options to be passed
    mkKeymapWithOpts =
      mode: key: action: desc: opts:
      (mkKeymap mode key action desc)
      // {
        options = opts;
      };

    # For which-key icon generation
    # Accepts a list of strings and returns a list of objects
    # [{ __unkeyed, icon, group, hidden <optional boolean> }]
    wKeyObj =
      with builtins;
      list:
      {
        __unkeyed = elemAt list 0;
        icon = elemAt list 1;
        group = elemAt list 2;
      }
      // lib.optionalAttrs (length list > 3) {
        hidden = elemAt list 3;
      };
  };
}
