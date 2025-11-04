# https://nix-community.github.io/plasma-manager/options.xhtml

{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;
  term = if (toggles.wezterm.enable or false) then "wezterm" else "konsole";
  ruskWallpaper = pkgs.fetchurl {
    url = "https://deprived.dev/assets/zhen/nixos/RuskBackground-nix.png";
    hash = "sha256-bvwUuWclgAo3aBmG2H65YRUIFgh2xjiHMsICcZQOQf8=";
  };


  # wrapper that reads /etc/nixos/.env at runtime (impure) ChatGPT, because i don't care if it works
  haScene = pkgs.writeShellScriptBin "ha-scene" ''
    set -euo pipefail
    # Load secrets (impure)
    if [ -f /etc/nixos/.env ]; then set -a; . /etc/nixos/.env; set +a; fi

    scene=${"\${1:?usage: ha-scene <scene.entity_id>}"}   # <-- no backslash before {
    data='{"entity_id":"'"$scene"'"}'

    exec ${pkgs.curl}/bin/curl -sS -X POST https://ha.deprived.dev/api/services/scene/turn_on \
      -H "Authorization: Bearer ${"\${HA_TOKEN}"}" \
      -H "Content-Type: application/json" \
      -d "$data"
  '';
in
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      wallpaper = ruskWallpaper;
      colorScheme = "BreezeDark";
      theme = "breeze_cursors";
      #
    };

    powerdevil.AC = {
      autoSuspend.action = "nothing";
      powerButtonAction = "shutDown";
    };

    session.sessionRestore.restoreOpenApplicationsOnLogin =
      "startWithEmptySession";

    kscreenlocker = {
      #         lockOnStartup = false;
      # lockOnResume = false;
      passwordRequired = false;
    };

    # Shortcuts =====================================
    shortcuts = {
      plasmashell."activate application launcher" = "Meta+S";
      plasmashell."kill window" = "Shift+Alt+F4";
      kwin = { "Window Maximize" = "Meta+Up"; };

    };

    hotkeys.commands = {
      "launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Return";
        command = term;
      };

      "launch-konsole2" = {
        name = "Launch Konsole";
        key = "Meta+F1";
        command = term;
      };

      "launch-missioncenter" = {
        name = "Launches the windows task manager alternative";
        key = "Ctrl+Shift+Esc";
        command = "missioncenter";
      };

      "screenshot-to-clipboard" = {
        name = "Region screenshot to clipboard";
        key = "Meta+Shift+S";
        command = "spectacle -brc";
      };

      "qalculate" = {
        name = "Windows like quick calculate";
        key = "Alt+Space";
        command = "qalculate-qt";
      };

      "ha-concentrate" = {
        name = "Set bedroom lights to concentrate";
        key = "Meta+F12";
        command = "ha-scene scene.concentrate";
      };
      "ha-minimal" = {
        name = "Set bedroom lights to minimal";
        key = "Meta+F11";
        command = "ha-scene scene.normal";
      };
      "ha-normal" = {
        name = "Turn bedroom lights to normal";
        key = "Meta+F10";
        command = "ha-scene scene.minimal";
      };
      "ha-off" = {
        name = "Turn off bedroom lights";
        key = "Meta+F9";
        command = "ha-scene scene.off_lights";
      };
    };

    spectacle.shortcuts.launch = "";

    # input.mice.* = {
    #     enable = true;
    #     acceleration = 0;
    #     accelerationProfile = "none";
    #   };

    window-rules = [
      {
        description = "Keep Qalculate on top";
        match = {
          window-class = {
            value = ".*Qalculate.*";
            type = "regex";
            match-whole = false;
          };
        };
        apply = {
          above = {
            value = true;
            apply = "force";
          };
        };
      }
    ];
    configFile = {
      # Naw, screw the volume change sound notification
      "plasmaparc"."General"."AudioFeedback" = false;
      # Screw this advertizement for firefox extension
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      # Fuck the hot corner thingy that makes overview
      "kwinrc"."Effect-overview"."BorderActivate" = 9;
      "kdeglobals"."General"."fixed" =
        "CozetteVector-nerd,10,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,nerd";
      "kdeglobals"."General"."TerminalApplication" = "wezterm start --cwd .";
      "kdeglobals"."General"."TerminalService" = "org.wezfurlong.wezterm.desktop";
      "klaunchrc"."BusyCursorSettings"."Bouncing" = false;
      "klaunchrc"."FeedbackStyle"."BusyCursor" = false;
      "klaunchrc"."FeedbackStyle"."TaskbarButton" = false;

      # # Dolphin shit
      # "dolphinrc"."General"."GlobalViewProps" = false;
      # "dolphinrc"."General"."ViewPropsTimestamp" = "2025,9,25,0,13,56.194";
      # "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      # "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      # "dolphinrc"."PreviewSettings"."Plugins" =
      #   "cursorthumbnail,windowsexethumbnail,ebookthumbnail,appimagethumbnail,djvuthumbnail,audiothumbnail,windowsimagethumbnail,opendocumentthumbnail,directorythumbnail,exrthumbnail,jpegthumbnail,imagethumbnail,comicbookthumbnail,svgthumbnail,kraorathumbnail,fontthumbnail,calligrathumbnail,blenderthumbnail,mobithumbnail,gsthumbnail,pothumbnail,calligraimagethumbnail,rawthumbnail,ffmpegthumbs";
    };
  };

  home.packages = with pkgs; [
    qalculate-qt
    haScene
  ];

  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Close When Idle=false
    Close on Screensaver=false
    Enabled=false
    First Use=false
    Idle Timeout=10
    Launch Manager=false
    Leave Manager Open=false
    Leave Open=true
    Prompt on Open=false
    Use One Wallet=true

    [org.freedesktop.secrets]
    apiEnabled=true
  '';

  systemd.user.services.xbindkeys = {
    Unit = {
      Description = "xbindkeys daemon";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
      ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n";
      Restart = "on-failure";
    };
  };

  programs = {
    konsole = {
      enable = true;
      defaultProfile = "main";

      profiles."main" = {
        font = {
          name = "CozetteVector-nerd";
          size = 14;
        };

        # extraConfig = { Keyboard = { "Control+V" = "paste"; }; };
      };
    };
  };
}
