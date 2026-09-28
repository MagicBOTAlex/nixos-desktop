{ pkgs, ... }:

{
  systemd.user.services.dbus-docker-proxy = {
    description = "D-Bus session bus proxy for Docker root containers";
    after = [ "dbus.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.socat}/bin/socat \
          UNIX-LISTEN:%t/dbus-docker-proxy.sock,fork,mode=777,unlink-early \
          UNIX-CONNECT:%t/bus
      '';
      Restart = "always";
      RestartSec = 2;
    };
  };
}
