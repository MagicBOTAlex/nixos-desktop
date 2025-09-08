{ pkgs, ... }:
let
  ruskWallpaper = pkgs.fetchurl {
    url = "https://deprived.dev/assets/zhen/nixos/RuskBackground-nix.png";
    hash = "sha256-bvwUuWclgAo3aBmG2H65YRUIFgh2xjiHMsICcZQOQf8=";
  };
in {
  programs.plasma = {
    enable = true;
    # overrideConfig = true;
    workspace = {
      wallpaper = ruskWallpaper;
      colorScheme = "BreezeDark";
      #
    };

    session.sessionRestore.restoreOpenApplicationsOnLogin =
      "startWithEmptySession";

    # Shortcuts =====================================
    shortcuts = {
      plasmashell."activate application launcher" = "Meta+S";
      plasmashell."kill window" = "Shift+Alt+F4";

    };

    hotkeys.commands = {
      "launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Return";
        command = "konsole";
      };

      "launch-konsole2" = {
        name = "Launch Konsole";
        key = "Meta+F1";
        command = "konsole";
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
    };

    spectacle.shortcuts.launch = "";

    # input.mice.* = {
    #     enable = true;
    #     acceleration = 0;
    #     accelerationProfile = "none";
    #   };
  };

  home.packages = with pkgs; [ qalculate-qt ];

  #   home.file.".xbindkeysrc".text ="
  # \"xvkbd -xsendevent -text \"{\"\"
  # m:0xc + c:16
  # Control+Alt + 7
  #
  # \"xvkbd -xsendevent -text \"[\"\"
  # m:0xc + c:16
  # Control+Alt + 8
  #
  # \"xvkbd -xsendevent -text \"]\"\"
  # m:0xc + c:16
  # Control+Alt + 9
  #
  # \"xvkbd -xsendevent -text \"}\"\"
  # m:0xc + c:16
  # Control+Alt + 0";

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

  # # Doesn't work because NixOS bad
  # home.file.".config/dolphinrc".text = ''
  #   [General]
  #   ShowHiddenFiles=true
  #
  #   [DetailsMode]
  #   PreviewSize=16
  #
  #   [PreviewSettings]
  #   Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,pothumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,textthumbnail,ffmpegthumbnail
  # '';

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
