{ pkgs, ... }: {
  users.users.botmain = {
    isNormalUser = true;
    description = "botmain";
    extraGroups =
      [ "projects" "networkmanager" "kvm" "adbusers" "wheel" "docker" "udev" "dialout" "wheel" "sensors" "plugdev" "android-udev" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDya8UyKVEOimjHyiZOsRicB2aZsko8bOoDyamFzo4+n u0_a430@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhiPhFbCi64NduuV794omgS8mctBLXtqxbaEJyUo6lg botalex@DESKTOPSKTOP-ENDVV0V"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFhTExbc9m4dCK6676wGiA8zPjE0l/9Fz2yf0IKvUvg snorre@archlinux"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxUPAsPkri0B+xkO3sCHJZfKgAbgPcepP8J4WW4yyLj u0_a167@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfQLOKUnOARUAs8X1EL1GRHoCQ0oMun0vzL7Z78yOsM nixos@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw1ckvXz78ITeqANrWSkJl6PJo2AMA4myNrRMBAB7xW zhentao2004@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyZOZlcQBmqSPxjaGgE2tP+K7LYziqjFUo3EX12rGtf botlap@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJF+y+ito2eLe4TTPZyZFe04REpuUcrNvGrY9AfguM+ root@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1EIniHJtC4VmD5hRKy5+LjG0tCLmPTy+s9Z7GnrW5a1sGeo5J30I6sZSNaakF3LDlbJBsjD/pz6XhIOT2qSXEAH7diwjKA79lCHaZeAsrj4nLsYkC3Z/svODRLStp6e+rPFE+WIfy9CvDtGZnCzcNaic7OiUD7CdxBF/AP2gMkHFRiS4VWWE8/ZBt0o8AnUyvlO1rTzrlM29ag4ycf9EhBkgk1HsSpQZiXqMNmFtygoylrY504TZXRm8q1Wx2WUkNm6ETHvtx7LmMnEkATwCqScLSAp65o/55PWjY3sQ0ncCAfH7dYMgNwk+ZCLMkB2jWA7JEWPkgcz8siZZHxhrp u0_a430@localhost"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhiPhFbCi64NduuV794omgS8mctBLXtqxbaEJyUo6lg botalex@DESKTOPSKTOP-ENDVV0V"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFhTExbc9m4dCK6676wGiA8zPjE0l/9Fz2yf0IKvUvg snorre@archlinux"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxUPAsPkri0B+xkO3sCHJZfKgAbgPcepP8J4WW4yyLj u0_a167@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfQLOKUnOARUAs8X1EL1GRHoCQ0oMun0vzL7Z78yOsM nixos@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw1ckvXz78ITeqANrWSkJl6PJo2AMA4myNrRMBAB7xW zhentao2004@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyZOZlcQBmqSPxjaGgE2tP+K7LYziqjFUo3EX12rGtf botlap@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJF+y+ito2eLe4TTPZyZFe04REpuUcrNvGrY9AfguM+ root@nixos"
    ];
  };

  users.users.test = {
    isNormalUser = true;
    description = "testing";
    extraGroups =
      [ "networkmanager" "wheel" "docker" "udev" "dialout" "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhiPhFbCi64NduuV794omgS8mctBLXtqxbaEJyUo6lg botalex@DESKTOPSKTOP-ENDVV0V"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFhTExbc9m4dCK6676wGiA8zPjE0l/9Fz2yf0IKvUvg snorre@archlinux"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxUPAsPkri0B+xkO3sCHJZfKgAbgPcepP8J4WW4yyLj u0_a167@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfQLOKUnOARUAs8X1EL1GRHoCQ0oMun0vzL7Z78yOsM nixos@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJw1ckvXz78ITeqANrWSkJl6PJo2AMA4myNrRMBAB7xW zhentao2004@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyZOZlcQBmqSPxjaGgE2tP+K7LYziqjFUo3EX12rGtf botlap@nixos"
    ];
  };

  # Group for read-only sensor access
  users.groups.sensors = { };

  # Relax permissions on powercap + hwmon power files
  services.udev.extraRules = ''
    SUBSYSTEM=="powercap", KERNEL=="intel-rapl:*", MODE="0444", GROUP="sensors"
    SUBSYSTEM=="powercap", KERNEL=="amd-rapl:*",   MODE="0444", GROUP="sensors"
    SUBSYSTEM=="hwmon",    KERNEL=="hwmon*", ATTR{power*_input}=="*", MODE="0444", GROUP="sensors"
  '';

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=300
  '';
}
