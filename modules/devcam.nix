{ pkgs
, ...
}: {
  systemd.services.devcam = {
    description = "dev cam for remote dev";

    # Unit requirements
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      # Use the kubelet binary from the Nix store
      ExecStart = ''${pkgs.mjpg-streamer}/bin/mjpg_streamer -i "input_uvc.so -d /dev/video2 -f 30 -r 1920x1080" -o "output_http.so -p 3232 -l 0.0.0.0"'';


      Restart = "always";
      RestartSec = 10;
    };

    # Systemd 230+ uses StartLimitIntervalSec in the [Unit] section
    unitConfig = {
      StartLimitIntervalSec = 0;
    };

    # Equivalent to [Install] WantedBy
    wantedBy = [ "multi-user.target" ];
  };
}
