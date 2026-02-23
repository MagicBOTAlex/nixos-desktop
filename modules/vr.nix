{ config, lib, pkgs, inputs, ... }:
let
  modded-oscavmgr = pkgs.oscavmgr.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "MagicBOTAlex";
      repo = "oscavmgr";
      rev = "b455883";
      hash = "sha256-mY2CPtEGktmIlVto/UaNLtRyT9A88cS+KcRYKVlV394=";
    };
  });
  toggles = import ./../toggles.nix;

  steamUser = "botmain"; # Target linux user
  vrPath = "/home/${steamUser}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";

  selectedWivrn = pkgs.wivrn.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      (lib.cmakeBool "WIVRN_FEATURE_DEBUG_GUI" true)
      (lib.cmakeBool "XRT_FEATURE_OPENXR_LAYER_COLOR_SCALE_BIAS" true)
    ];
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.sdl2-compat
      pkgs.systemd
      #
    ];
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];

    postInstall = (oldAttrs.postInstall or "") + ''
      # Wrap all executables with proper library path
                for binary in $out/bin/*; do
      if [[ -f "$binary" && -x "$binary" ]]; then
      wrapProgram "$binary" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [ pkgs.systemd pkgs.udev ]
      }"
      fi
      done
    '';
  });

  randomLibs = with pkgs; [
    alsa-lib
    atk
    cairo
    dbus
    fontconfig
    gdk-pixbuf
    glib
    gtk3
    libGL
    libclang
    libxkbcommon
    openssl
    openvr
    openxr-loader
    pango
    pipewire
    wayland
    libX11
    libXext
    libXrandr
    libxcb
  ];

  selectedWlx = pkgs.wayvr;

  # selectedWlx = pkgs.wlx-overlay-s.overrideAttrs (final: old: {
  #   buildInputs = randomLibs;
  #   src = pkgs.fetchFromGitHub {
  #     owner = "MagicBOTAlex";
  #     repo = "wlx-overlay-s";
  #     rev = "main";
  #     hash = "sha256-RCJWi5NGyS7wWb3XDrG8XRNizuiitRc06eksxfLvyws=";
  #   };
  #
  #   postPatch = ''
  # '';

  # });
  # selectedWlx = pkgs.wlx-overlay-s.overrideAttrs (final: old: {
  #   buildInputs = randomLibs;
  #   src = pkgs.fetchFromGitHub {
  #     owner = "galister";
  #     repo = "wlx-overlay-s";
  #     rev = "next";
  #     hash = "sha256-qPS20ijPG6Qa1g6iZOgC/gRwtzsvkPyAFLbIaGn/nIU=";
  #   };
  #
  #   cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
  #     inherit (final) src patches;
  #     inherit (old.cargoDeps) name;
  #     hash = "sha256-ISKsYwIC1R4nMzakStKrCEtOxJfne8H6TCQLpNG6owE=";
  #   };
  #
  #   postPatch = ''
  # '';
  #   postInstall = ''
  #   '';
  #   desktopItems = [
  #     (pkgs.makeDesktopItem {
  #       name = "wlx-overlay-s";
  #       desktopName = "WlxOverlay-S";
  #       exec = "wlx-overlay-s";
  #       icon = "wlx-overlay-s";
  #       terminal = true;
  #       categories = [
  #         "Utility"
  #         "X-WiVRn-VR"
  #       ];
  #     })
  #   ];
  #
  # });



in
{

  config = lib.mkIf toggles.vr.enable {
    environment.systemPackages = with pkgs;
      [
        motoc # Quest to PC tracking calibration
        # Requires "--fallback" in sudo nixos-rebuild switch --flake /etc/nixos --impure  --fallback
        selectedWlx
        # (pkgs.callPackage ./submodules/vrcft.nix { })
        modded-oscavmgr
        vrcadvert
        # inputs.avalonia.packages.x86_64-linux.default
        eepyxr
        bs-manager
        openvr
        slimevr
        # wivrn
        android-tools
      ] ++ randomLibs;

    systemd.user.services.wayvr = {
      description = "wayvr";

      # Start in the user session
      wantedBy = [ "default.target" ];

      # Unlimited restarts
      startLimitIntervalSec = 0;
      startLimitBurst = 0;

      serviceConfig = {
        ExecStart = "${pkgs.wayvr}/bin/wayvr";
        Restart = "always";
        RestartSec = 1;
      };
    };

    services.wivrn = {
      enable = true;
      openFirewall = true;
      highPriority = true;
      autoStart = true;
      # package = (pkgs.callPackage ./customPackages/wivrn/wivrn.nix { }).overrideAttrs (oldAttrs: {
      package = selectedWivrn;

      defaultRuntime = true;
    };

    services.udev.extraRules = ''
      # SlimeVR Dongle (1209:7690)
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7690", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7690", MODE="0666"

      # SlimeVR Tracker via USB (1209:7692) - Needed for wired connection/debugging
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7692", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7692", MODE="0666"
    '';

    # # Root oneshot that grants CAP_SYS_NICE to vrcompositor-launcher
    # systemd.services.steamvr-cap-sys-nice = {
    #   description = "Grant CAP_SYS_NICE to SteamVR vrcompositor-launcher";
    #   after = [ "local-fs.target" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+eip ${vrPath}";
    #   };
    #   wantedBy = [ "multi-user.target" ];
    # };
    #
    # # Re-run the service whenever the binary appears/changes
    # systemd.paths.steamvr-cap-sys-nice = {
    #   wantedBy = [ "multi-user.target" ];
    #   pathConfig = {
    #     PathExists = vrPath;
    #     PathChanged = vrPath;
    #   };
    # };
  };
}
