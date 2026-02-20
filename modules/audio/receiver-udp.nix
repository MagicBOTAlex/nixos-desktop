{ config, pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;

    # We keep your existing RTP Source, but we ADD the Loopback module below it
    extraConfig.pipewire."50-rtp-receiver" = {
      "context.modules" = [
        # 1. THE RECEIVER (Listens to network)
        {
          name = "libpipewire-module-rtp-source";
          args = {
            "source.ip" = "0.0.0.0";
            "source.port" = 46000;
            "sess.latency.msec" = 100;
            # Crucial: We name this node so we can grab it later
            "node.name" = "rtp-receiver";
          };
        }

        # 2. THE BRIDGE (Plays network audio to speakers)
        {
          name = "libpipewire-module-loopback";
          args = {
            "audio.position" = [ "FL" "FR" ];

            # CAPTURE: Grab audio FROM the network node
            "capture.props" = {
              "node.target" = "rtp-receiver";
              "media.class" = "Stream/Input/Audio";
            };

            # PLAYBACK: Send audio TO your default speakers
            "playback.props" = {
              "media.class" = "Stream/Output/Audio";
              "node.name" = "rtp-loopback";
              "node.description" = "Network Audio Loopback";
            };
          };
        }
      ];
    };
  };
}
