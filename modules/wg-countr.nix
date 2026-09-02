{ config, pkgs, ... }:

{
  # Set global DNS servers (from your config)
  networking.nameservers = [ "1.1.1.1" ];

  # Configure the WireGuard interface
  networking.wireguard.interfaces = {
    # Name of the interface (e.g., wg0)
    wg-countr = {
      # The IP address assigned to your interface
      ips = [ "198.222.0.4/24" ];

      # Path to the file containing your private key
      privateKeyFile = "/wireguard/wg-countr-privatekey";

      dynamicEndpointRefreshSeconds = 0;

      peers = [
        {
          publicKey = "smhjztUH9NA+Nal+YHrmDQVgOtN01EPhASvgPlkQmRc=";
          endpoint = "192.168.50.82:51100";
          allowedIPs = [ "198.222.0.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
