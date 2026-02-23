{ pkgs, ... }: {
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhiPhFbCi64NduuV794omgS8mctBLXtqxbaEJyUo6lg botalex@DESKTOPSKTOP-ENDVV0V"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFhTExbc9m4dCK6676wGiA8zPjE0l/9Fz2yf0IKvUvg snorre@archlinux"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxUPAsPkri0B+xkO3sCHJZfKgAbgPcepP8J4WW4yyLj u0_a167@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfQLOKUnOARUAs8X1EL1GRHoCQ0oMun0vzL7Z78yOsM nixos@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw1ckvXz78ITeqANrWSkJl6PJo2AMA4myNrRMBAB7xW zhentao2004@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhcUZbIMX0W27l/FMF5WijpdsJAK329/P008OEAfcyz botmain@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILB0esg3ABIcYWxvQKlPuwEE6cbhNcWjisfky0wnGirJ root@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxUPAsPkri0B+xkO3sCHJZfKgAbgPcepP8J4WW4yyLj u0_a167@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyZOZlcQBmqSPxjaGgE2tP+K7LYziqjFUo3EX12rGtf botlap@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLSUXsao6rjC3FDtRHhh7z6wqMtA/mqL50e1Dj9a2wE botserver@botserver"
    ];

    shell = pkgs.fish;

  };

  programs.fish = { enable = true; };
  documentation.man.generateCaches = false;

  services.openssh = { enable = true; };
  imports = [ ./kubernetes.nix ];
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
    busybox
    gcc
    tree-sitter
    busybox
    nodejs_22
    screen
    fastfetch
    btop
    openssh
    ripgrep
    dig
  ];

  systemd.services."load-br_netfilter" = {
    enable = true;
    description = "Modprobe br_netfilter";
    before = [ "flannel.service" ];
    wantedBy = [ "multi-user.target" "flannel.service" ];

    script = ''
      ${pkgs.kmod}/bin/modprobe br_netfilter
    '';
  };

  # --- MicroVM Specific Settings ---
  microvm = {
    # Choose your hypervisor: "qemu", "firecracker", "cloud-hypervisor", etc.
    hypervisor = "qemu";

    qemu.extraArgs = [
      "-netdev"
      "user,id=net0,net=192.168.76.0/24,dhcpstart=192.168.76.10,hostfwd=tcp::2223-:22"
      "-device"
      "virtio-net-pci,netdev=net0"

    ];

    # Mount the host's /nix/store explicitly (read-only)
    # This makes the VM start instantly as it shares the host store.
    shares = [{
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }
      {
        proto = "9p";
        tag = "docking-mount";
        # Source path can be absolute or relative
        # to /var/lib/microvms/$hostName
        source = "../shared/docking";
        mountPoint = "/root/docking";
      }
      {
        proto = "9p";
        tag = "config";
        source = "../shared/.config";
        mountPoint = "/root/.config";
      }
      {
        proto = "9p";
        tag = "local";
        source = "../shared/.local";
        mountPoint = "/root/.local";
      }];

    # Writable disk allocation
    volumes = [{
      image = "/var/lib/microvms/kube-desk/kube-desk.img";
      mountPoint = "/";
      size = 512 * 4; # Size in MB
    }];
  };
  systemd.tmpfiles.rules = [
    "d  /root/.kube       0755  root  root  -"
    "d  /root/.config       0755  root  root  -"
    "d  /root/.local       0755  root  root  -"
  ];


  stdenv.hostPlatform.system.stateVersion = "24.11";
}
