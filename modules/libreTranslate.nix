{ pkgs, ... }:
{

  networking.firewall.allowedUDPPorts = [ 1422 ];
  networking.firewall.allowedTCPPorts = [ 1422 ];
  services.libretranslate = {
    enable = true;

    host = "0.0.0.0";
    port = 1422;

    updateModels = true;
  };
}
