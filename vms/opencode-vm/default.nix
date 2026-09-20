{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ virtiofsd ];
  microvm.autostart = [ "opencode-vm" ];
  microvm.vms."opencode-vm" = {
    config = ./opencode-vm.nix;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/microvms/shared 0755 microvm kvm -"
    "d /var/lib/microvms/shared/desktop 0755 microvm kvm -"
    "d /var/lib/microvms/shared/.config 0755 microvm kvm -"
    "d /var/lib/microvms/shared/.local 0755 microvm kvm -"
  ];

}
