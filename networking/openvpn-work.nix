{ pkgs, ... }:
let
  # # Create a derivation that copies all VPN files to the Nix store
  # vpnConfig = pkgs.stdenv.mkDerivation {
  #   name = "work-vpn-config";
  #   src = /mnt/win/Users/BOTAlex/OpenVPN/config;
  #
  #   buildPhase = ''
  #     # Read the original config file
  #     cp updated.ovpn updated-fixed.ovpn
  #
  #     # Replace all relative paths with absolute paths in the Nix store
  #     substituteInPlace updated-fixed.ovpn \
  #       --replace "pfSense-UDP4-1195-annotator_cert-tls.key" "$out/pfSense-UDP4-1195-annotator_cert-tls.key" \
  #       --replace "pfSense-UDP4-1195-annotator_cert.p12" "$out/pfSense-UDP4-1195-annotator_cert.p12" \
  #       --replace "balls.txt" "$out/balls.txt"
  #   '';
  #
  #   installPhase = ''
  #     # Create output directory
  #     mkdir -p $out
  #
  #     # Copy all files to the Nix store
  #     cp pfSense-UDP4-1195-annotator_cert-tls.key $out/
  #     cp pfSense-UDP4-1195-annotator_cert.p12 $out/
  #     cp balls.txt $out/
  #     cp README.txt $out/
  #     cp pfSense-UDP4-1195-annotator_cert-config.ovpn $out/
  #
  #     # Install the fixed config
  #     cp updated-fixed.ovpn $out/updated.ovpn
  #   '';
  # };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      openvpn = prev.openvpn.override { openssl = prev.openssl_legacy; };
    })
  ];

  # services.openvpn.servers = {
  #   work = {
  #     updateResolvConf = true;
  #     # Use 'config' with builtins.readFile to read the fixed config
  #     config = builtins.readFile "${vpnConfig}/updated.ovpn";
  #     autoStart = false;
  #   };
  #   };

  systemd.services.openvpn-work = {
    description = "OpenVPN – work";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    # no wantedBy => it won't autostart (matches autoStart = false)
    wantedBy = [ ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openvpn}/bin/openvpn --config /mnt/win/Users/BOTAlex/OpenVPN/config/updated.ovpn";
      Restart = "on-failure";
    };
  };
}
