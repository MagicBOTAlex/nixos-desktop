{
  pkgs,
  ...
}:
{
  systemd.services.devcam = {
    description = "dev cam for remote dev";

    # Unit requirements
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      # Use writeShellScript to safely separate the bash logic from systemd's parser
      ExecStart = pkgs.writeShellScript "devcam-start" ''
        for dev in /dev/video*; do
          # Skip loop if no video devices exist and glob returns literal string
          [ -e "$dev" ] || continue

          echo "Trying camera device: $dev"
          ${pkgs.mjpg-streamer}/bin/mjpg_streamer -i "input_uvc.so -d $dev -f 30 -r 1920x1080" -o "output_http.so -p 3232 -l 0.0.0.0" &
          PID=$!
          
          # Wait a moment to see if it crashes immediately
          sleep 2
          if kill -0 $PID 2>/dev/null; then
            echo "Successfully started on $dev"
            wait $PID
            exit 0
          fi
          echo "$dev failed, trying next device..."
        done

        echo "No working video devices found."
        exit 1
      '';

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
