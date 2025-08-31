{ config, lib, pkgs, ... }:
let toggles = import ./../toggles.nix;
in {
  config = lib.mkIf toggles.vr.enable {
    xdg.configFile."wlxoverlay/wayvr.conf.d".text = ''
      dashboard:
        exec: "${pkgs.wayvr-dashboard}/bin/wayvr-dashboard"
        args: ""
        env: []
    '';
  };
}
