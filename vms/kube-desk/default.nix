{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ virtiofsd ];
  microvm.autostart = [ "kube-desk" ];
  microvm.vms."kube-desk" = { config = ./kube-desk.nix; };

  systemd.tmpfiles.rules = [
    "d /var/lib/microvms/shared 0755 microvm kvm -"
    "d /var/lib/microvms/shared/docking 0755 microvm kvm -"
    "d /var/lib/microvms/shared/.config 0755 microvm kvm -"
    "d /var/lib/microvms/shared/.local 0755 microvm kvm -"
  ];

}
