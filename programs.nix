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
    # discord
    killall
    # fontforge
    gparted
    prismlauncher
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
    (pkgs.callPackage ./modules/customPackages/rustdesk/rustdesk.nix { })
    (pkgs.callPackage ./modules/customPackages/shreddit/shreddit.nix { })

    inkscape
    immich-cli
    drawio
    sg3_utils
    linuxKernel.packages.linux_6_12.turbostat
    unityhub
    cheese
    legendary-gl
    yt-dlp

    wineWowPackages.waylandFull
    winetricks
    vulkan-loader
    vulkan-validation-layers
    (pkgs.wine.override { wineBuild = "wine64"; })
    conky
    gitoxide

    libreoffice-fresh
    hunspell
    hunspellDicts.da-dk
    appimage-run
  ];

  programs.noisetorch.enable = true;
  programs.starship.enable = true;
  nixpkgs.config.permittedInsecurePackages = [
    "libxml2-2.13.8" # For unityhub
    "libsoup-2.74.3" # Unityhub
  ];
}
