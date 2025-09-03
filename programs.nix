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
    sublime

    libreoffice-fresh
    hunspell
    hunspellDicts.da-dk
  ];

  programs.starship.enable = true;
}
