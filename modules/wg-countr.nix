{ config, pkgs, ... }:

{
  # Set global DNS servers (from your config)
  networking.nameservers = [ "1.1.1.1" ];

  # Configure the WireGuard interface
  networking.wireguard.interfaces = {
    # Name of the interface (e.g., wg0)
    wg-countr = {
      # The IP address assigned to your interface
      ips = [ "198.18.0.3/24" ];

      # Path to the file containing your private key
      privateKeyFile = "/wireguard/wg-countr-privatekey";

      peers = [
        {
          publicKey = "smhjztUH9NA+Nal+YHrmDQVgOtN01EPhASvgPlkQmRc=";
          endpoint = "176.23.63.215:51100";
          allowedIPs = [ "198.18.0.3/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
