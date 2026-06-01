{ pkgs, ... }:
{
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # This injects our notch filter module directly into PipeWire's configuration
    extraConfig.pipewire."99-notch-filter" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Notch Filter (6400Hz)";
            "media.name" = "Notch Filter (6400Hz)";
            "filter.graph" = {
              nodes = [
                {
                  type = "builtin";
                  name = "notch_L";
                  label = "bq_notch";
                  control = {
                    Freq = 6500.0;
                    Q = 5.0;
                  };
                }
                {
                  type = "builtin";
                  name = "notch_R";
                  label = "bq_notch";
                  control = {
                    Freq = 6400.0;
                    Q = 5.0;
                  };
                }
              ];
              inputs = [
                "notch_L:In"
                "notch_R:In"
              ];
              outputs = [
                "notch_L:Out"
                "notch_R:Out"
              ];
            };
            "capture.props" = {
              "node.name" = "effect.notch_6400_input";
              "media.class" = "Audio/Sink";
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
            "playback.props" = {
              "node.name" = "effect.notch_6400_output";
              "node.passive" = true;
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
          };
        }
      ];
    };
  };
}
