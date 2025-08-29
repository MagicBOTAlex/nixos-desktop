{ pkgs, ... }: {
  programs.plasma = {
    enable = true;
    # overrideConfig = true;
    workspace.colorScheme = "BreezeDark";

    # Shortcuts =====================================
    shortcuts = {
      plasmashell."activate application launcher" = "Meta+S";

    };

    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Return";
      command = "konsole";
    };

    hotkeys.commands."launch-konsole2" = {
      name = "Launch Konsole";
      key = "Meta+F1";
      command = "konsole";
    };

    hotkeys.commands."launch-missioncenter" = {
      name = "Launches the windows task manager alternative";
      key = "Ctrl+Shift+Esc";
      command = "missioncenter";
    };

    # input.mice.* = {
    #     enable = true;
    #     acceleration = 0;
    #     accelerationProfile = "none";
    #   };
  };

  # Doesn't work because NixOS bad
  home.file.".config/dolphinrc".text = ''
    [General]
    ShowHiddenFiles=true

    [DetailsMode]
    PreviewSize=16

    [PreviewSettings]
    Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,pothumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,textthumbnail,ffmpegthumbnail
  '';

  programs.konsole = {
    enable = true;
    defaultProfile = "main";

    profiles."main" = {
      font = {
        name = "CozetteVector-nerd";
        size = 14;
      };

      extraConfig = { Keyboard = { "Control+V" = "paste"; }; };
    };
  };
}
