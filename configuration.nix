# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# All overlays given by flakes
flake-overlays:

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./aliases.nix
    # ./docker.nix
    ./modules/drivers/nvidia.nix
    ./modules/drivers/bluetooth.nix
    ./modules/drivers/amdcpu.nix

    ./networking/openvpn-work.nix
    ./networking/networkSetup.nix

    ./programs.nix
    ./modules/python.nix
    ./modules/nodejs.nix
    ./modules/steam.nix
    ./modules/spotify.nix
    # ./modules/freecad.nix
    ./modules/customPackages/oscd.nix

    ./modules/fishShell.nix

    ./users.nix

    ./modules/de.nix

    # ./modules/displayOff.nix

    # Do not disable under here =========================== Disable in toggles.nix
    ./modules/vr.nix

  ];

  nix.settings = {
    # download-attempts = 1;
    # connect-timeout = 1;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.deprived.dev"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.deprived.dev:B5o97KpSrgbN7OxZCLu0LQYxg+Bj0pB1WiKY5n0HfLY="
    ];
  };

  nixpkgs.overlays = [
    (final: prev:
      {
        # Your own overlays...
      })
  ] ++ flake-overlays;
  environment.systemPackages = with pkgs; [ matlab ];

  # nix.settings.post-build-hook = pkgs.writeScript "upload-to-cache" ''
  #   #!/bin/sh
  #   set -eu
  #   export IFS=' '
  #   echo "Uploading paths" $OUT_PATHS
  #   exec ${pkgs.nix}/bin/nix copy --to https://cache.deprived.dev $OUT_PATHS
  # '';

  environment.variables.EDITOR = "nvim";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # dont worry about it
  nix = {
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
    settings = {
      nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
      flake-registry = ""; # optional, ensures flakes are truly self-contained
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
    };
  };

  services.openssh = { enable = true; };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users = { "botmain" = import ./home.nix; };
  };

  # Root uses the exact same module
  home-manager.users.root = { pkgs, ... }: {
    home.stateVersion = "24.05";
    imports = [ ./modules/nvim.nix ];
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "BOTAlex";
        email = "zhen@deprived.dev";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

