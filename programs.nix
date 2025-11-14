{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    wget
    iproute2
    curl
    fastfetch
    tree
    pigz
    ncdu
    screen
    nixfmt-tree
    ffmpeg-full

    ### Desktop programs
    wl-clipboard
    killall
    # fontforge
    gparted
    # prismlauncher
    mission-center
    ungoogled-chromium
    megasync
    dotnet-sdk_8
    nuget-to-json
    vlc
    filezilla
    arduino-ide
    krita
    jq
    sublime-merge
    blender
    # rustdesk
    # (pkgs.callPackage ./modules/customPackages/rustdesk/rustdesk.nix { })
    (pkgs.callPackage ./modules/customPackages/shreddit/shreddit.nix { })
    borgbackup
    pinta
    kdePackages.kdenlive
    kicad-unstable

    inkscape
    immich-cli
    drawio
    sg3_utils
    # linuxKernel.packages.linux_6_12.turbostat
    unityhub
    cheese
    legendary-gl # Epic games
    yt-dlp
    pigz
    heroic
    unzip

    wineWowPackages.waylandFull
    # winetricks
    vulkan-loader
    vulkan-validation-layers
    (pkgs.wine.override { wineBuild = "wine64"; })
    conky
    gitoxide

    libreoffice-fresh
    hunspell
    hunspellDicts.da-dk
    appimage-run
    go
    bruno

    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.breeze-icons
    kdePackages.dolphin-plugins
    kdePackages.kdesdk-thumbnailers # new
    kdePackages.kdegraphics-thumbnailers # new
    kdePackages.kdegraphics-mobipocket # new
    kdePackages.kimageformats # new
    kdePackages.calligra # new
    kdePackages.qtimageformats # new
    kdePackages.ffmpegthumbs # new
    kdePackages.taglib # new
    kdePackages.baloo # new
    kdePackages.baloo-widgets # new
    resvg # new
    kdePackages.dolphin
    kdePackages.kio-extras
    kdePackages.kimageformats
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    qt6.qtimageformats
    busybox
    libqalculate
    coppwr

  ];

  programs.noisetorch.enable = true;
  programs.nix-ld.enable = true;
  programs.starship.enable = true;
  nixpkgs.config.permittedInsecurePackages = [
    "libxml2-2.13.8" # For unityhub
    "libsoup-2.74.3" # Unityhub
  ];
}
