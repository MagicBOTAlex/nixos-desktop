{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ xmrig p2pool ];
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
}
