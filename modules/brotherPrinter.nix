{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ pkgs.brlaser brscan5 sane-airscan simple-scan ];
  services.ipp-usb.enable = true;

  boot.kernelModules = [ "nf_conntrack_ftp" ];

  services.vsftpd = {
    enable = true;
    localUsers = true; # Allow system users to login
    userlistEnable = true; # Enable the specific user list
    userlist = [ "scanner" ];

    # NixOS doesn't have dedicated options for these, so we put them in extraConfig:
    extraConfig = ''
      # 1. Write Permissions
      write_enable=YES
      
      # 2. Lock user to their folder (Chroot)
      chroot_local_user=YES
      # REQUIRED: Allow the user to write to their own locked folder
      allow_writeable_chroot=YES

      # 3. Printer Compatibility (Disable SSL if printer fails to connect)
      # Many scanners fail if these are set to YES (the default)
      force_local_data_ssl=NO
      force_local_logins_ssl=NO
    '';
  };

  # ... (Rest of your user and firewall config remains the same)
  users.users.scanner = {
    isNormalUser = true;
    home = "/home/scanner";
    createHome = true;
    group = "users";
  };

  networking.firewall.allowedTCPPorts = [ 20 21 ];
}
