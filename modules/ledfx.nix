{ pkgs, ... }:
{
  systemd.user.services.ledfx = {
    description = "LedFX reactive lights controller";

    # Start in the user session
    wantedBy = [ "default.target" ];

    # Unlimited restarts
    startLimitIntervalSec = 0;
    startLimitBurst = 0;

    serviceConfig = {
      # This adds the 1-second delay before the main process starts
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";

      ExecStart = "${pkgs.ledfx}/bin/ledfx";
      Restart = "always";
      RestartSec = 1;
    };
  };
}
