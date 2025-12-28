{ pkgs, ... }: {
  systemd.user.services.ledfx = {
    description = "LedFX reactive lights controller";

    # Start in the user session
    wantedBy = [ "default.target" ];

    # Unlimited restarts
    startLimitIntervalSec = 0;
    startLimitBurst = 0;

    serviceConfig = {
      ExecStart = "${pkgs.ledfx}/bin/ledfx";
      Restart = "always";
      RestartSec = 1;
    };
  };

}
