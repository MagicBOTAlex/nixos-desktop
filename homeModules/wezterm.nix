{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;

  # 1. Define the logo
  customLogo = pkgs.fetchurl {
    url = "https://static.wikia.nocookie.net/feed-the-beast/images/0/07/Iso_Computer.png/revision/latest?cb=20130214161136";
    sha256 = "sha256-LLFe13tuWn+TrNeFSMfmKe+9ZUxmxHT/hVcdbyRpBIc=";
  };

in
{
  programs.wezterm = {
    enable = true;
    # Do not override 'package' here unless you build a full custom derivation.

    extraConfig = ''
      local wezterm = require "wezterm"
      local config = wezterm.config_builder()
      local act = wezterm.action

      config.font = wezterm.font("CozetteVector-nerd")
      config.font_size = 14.0

      config.keys = {
        { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
        { key = 'Backspace', mods = 'CTRL', action = act.SendKey({ key = 'w', mods = 'CTRL' }) },
        { key = 'v', mods = 'CTRL|SHIFT', action = act.SendKey { key = 'v', mods = 'CTRL' } },
        {
          key = 'D',
          mods = 'CTRL|SHIFT',
          action = act.DetachDomain 'CurrentPaneDomain',
        }
      }

      config.enable_wayland = false
      config.color_scheme = 'Catppuccin Mocha'

      return config
    '';

    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.plasma = {
    hotkeys.commands."wezterm" = {
      name = "Launch Wezterm";
      key = "Meta+F1";
      command = "wezterm";
    };
  };

  # 2. Override the Desktop Entry
  # We use the key "org.wezfurlong.wezterm" to overwrite the default one provided by the package.
  xdg.desktopEntries."org.wezfurlong.wezterm" = {
    name = "WezTerm";
    comment = "A GPU-accelerated cross-platform terminal emulator and multiplexer";
    # Point directly to the custom logo path
    icon = customLogo;
    exec = "wezterm start --cwd .";
    categories = [
      "System"
      "TerminalEmulator"
    ];
    terminal = false;

    # 3. Critical: Link the running window to this icon
    settings = {
      StartupWMClass = "org.wezfurlong.wezterm";
    };
  };
}
