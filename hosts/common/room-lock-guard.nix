{
  pkgs,
  store,
  ...
}: let
  room-lock-guard = pkgs.writeShellApplication {
    name = "room-lock-guard";
    runtimeInputs = [pkgs.libinput pkgs.util-linux pkgs.gnugrep pkgs.procps pkgs.python3 pkgs.findutils];
    text = builtins.readFile "${store}/.local/bin/room-lock-guard";
  };
in {
  systemd.services.room-lock-guard = {
    description = "Privacy guard for the sensitive Element room";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${room-lock-guard}/bin/room-lock-guard";
      Restart = "always";
      RestartSec = 1;
    };
  };
}
