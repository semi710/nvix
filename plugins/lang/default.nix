{ lib, pkgs, ... }:
{
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );

  # General file formatters
  plugins = {
    conform-nvim.settings = {
      formatters_by_ft = {
        xml = [ "xmllint" ];
        yaml = [ "yamlfix" ];
        json = [ "jq" ];
      };
      formatters = {
        xmllint.command = lib.getExe' pkgs.libxml2 "xmllint";
        jq = {
          command = lib.getExe pkgs.jq;
          args = [
            "-R"
            "fromjson? // ."
          ];
        };
        yamlfix.command = lib.getExe pkgs.yamlfix;
      };
    };
  };
}
