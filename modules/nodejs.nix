{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_24
    # nodePackages.live-server
    nodePackages.serve
  ];
}
