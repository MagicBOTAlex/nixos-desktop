{ pkgs, ... }:
let
  # Frequency where the reduction starts (Hz)
  freq = 200;
  # How much to reduce the bass (in dB). -10 is a noticeable cut.
  gain = -15;
  # Q factor for the shelf (usually 0.707 for a neutral slope)
  Q = 0.707;
in
{
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."99-bass-minimizer" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Bass Minimizer (${toString freq}Hz)";
            "media.name" = "Bass Minimizer";
            "filter.graph" = {
              nodes = [
                {
                  type = "builtin";
                  name = "lowshelf_L";
                  label = "bq_lowshelf";
                  control = {
                    Freq = toString freq;
                    Gain = toString gain;
                    Q = toString Q;
                  };
                }
                {
                  type = "builtin";
                  name = "lowshelf_R";
                  label = "bq_lowshelf";
                  control = {
                    Freq = toString freq;
                    Gain = toString gain;
                    Q = toString Q;
                  };
                }
              ];
              inputs = [
                "lowshelf_L:In"
                "lowshelf_R:In"
              ];
              outputs = [
                "lowshelf_L:Out"
                "lowshelf_R:Out"
              ];
            };
            "capture.props" = {
              "node.name" = "effect.bass_minimizer_input";
              "media.class" = "Audio/Sink";
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
            "playback.props" = {
              "node.name" = "effect.bass_minimizer_output";
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
