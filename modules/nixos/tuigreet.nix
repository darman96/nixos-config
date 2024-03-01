{ lib, config, pkgs, ... }:

let
  inherit (lib) mkOption types;

  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in

{
  options = {

    greeter = mkOption {
      type = types.submodule {
        options = {

          sessions = mkOption {
            type = types.listOf (types.str);

          };
        };
      };
    };

  };

  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --sessions ${lib.concatStringsSep ":" config.greeter.sessions}";
          user = "greeter";
        };
      };
    };

    security.pam.services.greetd.enableKwallet = true;
  };
}