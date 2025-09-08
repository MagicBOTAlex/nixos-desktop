{ pkgs, lib, ... }:
let toggles = import ./../toggles.nix;
in {
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require "wezterm"
      local config = wezterm.config_builder()

      config.font = wezterm.font("CozetteVector-nerd")
      config.font_size = 14.0

      config.keys = {
        -- Paste from clipboard
        {
          key = 'v',
          mods = 'CTRL',
          action = wezterm.action.PasteFrom 'Clipboard',
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

  xdg.desktopEntries.wezterm = {
    name = "WezTerm";
    comment =
      "A GPU-accelerated cross-platform terminal emulator and multiplexer";
    exec = "wezterm start --cwd .";
    icon = "wezterm";
    categories = [ "System" "TerminalEmulator" ];
  };
}
