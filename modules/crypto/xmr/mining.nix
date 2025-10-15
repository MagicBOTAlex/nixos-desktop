{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # xmrig
    (
      pkgs.callPackage ../../customPackages/p2pool/p2pool.nix { }
    )
    monero-cli
    # (pkgs.callPackage ../../customPackages/xmrig-cuda/xmrig-cuda.nix { })
    # (pkgs.callPackage ../../customPackages/gminer/gminer.nix { })
    # baller
  ];
  services.monero = {
    enable = true;

    # your priority peers
    priorityNodes = [
      "p2pmd.xmrvsbeast.com:18080"
      "nodes.hashvault.pro:18080"
    ];

    # pass raw monerod flags (same names as CLI without the --)
    extraConfig = ''
      zmq-pub=tcp://127.0.0.1:18083
      out-peers=32
      in-peers=64
      enforce-dns-checkpointing=1
      enable-dns-blocklist=1
      prune-blockchain=1
    '';
  };

  systemd.services.p2pool = {
    description = "Monero P2Pool";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";

      # ensure it actually dies on stop
      KillMode = "control-group"; # kill the whole cgroup
      KillSignal = "SIGINT"; # try graceful first (often what p2pool handles)
      TimeoutStopSec = 2; # wait this long, then...
      FinalKillSignal = "SIGKILL"; # ...force kill
      SendSIGKILL = true; # make sure SIGKILL is sent

      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${ (pkgs.callPackage ../../customPackages/p2pool/p2pool.nix { }) }/bin/p2pool --host 0.0.0.0 --stratum 0.0.0.0:3333 --wallet ${"$"}{XMR_WALLET}";
      Restart = "always";
      RestartSec = 5;
      EnvironmentFile = "/etc/nixos/.env";
    };
  };


  systemd.services.xmrig = {
    description = "XMRig Miner";
    wantedBy = [ "multi-user.target" ];
    after = [ "p2pool.service" "network-online.target" ];
    wants = [ "p2pool.service" "network-online.target" ];

    # Put needed binaries on PATH for this service
    path = with pkgs; [ xmrig coreutils bash linuxPackages.cpupower ];

    serviceConfig = {
      Type = "simple";
      EnvironmentFile = "/etc/nixos/.env"; # contains XMR_WALLET=...

      ExecStartPre = [
        "${pkgs.coreutils}/bin/sleep 5"
        # set temp max clock (needs root; this unit runs as root by default)
        "${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-set -u 3.0GHz"
      ];

      # Use a shell so $XMR_WALLET expands (systemd won’t expand it otherwise)
      ExecStart = ''
        ${pkgs.bash}/bin/bash -lc \
          '${pkgs.xmrig}/bin/xmrig -o 127.0.0.1:3333 -u "$XMR_WALLET" -k --coin monero'
      '';

      Restart = "always";
      RestartSec = 5;
      # Optional niceties:
      KillSignal = "SIGINT";
      Nice = -5;
    };
  };

}
