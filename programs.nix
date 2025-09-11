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
    firefox
    wl-clipboard
    discord
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
    rustdesk
    inkscape
    immich-cli
    drawio
    wine-wayland
    sg3_utils
    linuxKernel.packages.linux_6_12.turbostat

    libreoffice-fresh
    hunspell
    hunspellDicts.da-dk
  ];

  programs.starship.enable = true;
}
