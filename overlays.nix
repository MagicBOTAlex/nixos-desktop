{ config, pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      zenmonitor = prev.zenmonitor.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "detiam";
          repo = "zenmonitor3";
          rev = "1e1ceec7353dc418578fe8ae56536bfee6adeca3";
          sha256 = "sha256-q5BeLu0A2XJkJL8ptN4hj/iLhQmpb16QEhOuIhNzVaI=";
        };
      });
    })
  ];
}
