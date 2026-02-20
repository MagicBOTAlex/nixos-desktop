{ config, pkgs, ... }:

{
  # 1. Open the Port
  networking.firewall.allowedTCPPorts = [ 4713 ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;

    # 2. Define the Server as a Config Object
    extraConfig.pipewire-pulse."99-network-server" = {
      "context.modules" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            # LISTEN ON TCP PORT 4713
            "server.address" = [ "tcp:4713" ];

            # PERMISSIONS
            # "unrestricted" allows connected clients full control, 
            # but they usually still need the shared cookie.
            "client.access" = "unrestricted";
          };
        }
      ];
    };
  };
}
