{ pkgs, ... }: {
  programs.clash-verge = {
    enable = true;
    group = "clash";
    tunMode = true;
    serviceMode = true;
  };

  users.groups.clash = { };

  nixpkgs.overlays = [
    (final: prev: {

      mihomo_1_19_26 = prev.mihomo.overrideAttrs (old: rec {

        version = "1.19.26";

        src = final.fetchFromGitHub {
          owner = "MetaCubeX";
          repo = "mihomo";
          rev = "v${version}";
          hash = "sha256-As0MqIGHs1Gn+aUWpeFsC231n9v7lBNmGlQdAwVWcJs=";
        };

        vendorHash = "sha256-ySpBMR/djPPs1aTw7yiCrCFxDFsvRfTJEChg8v1C408=";
      });

      clash-verge-rev = prev.clash-verge-rev.override {

        mihomo = final.mihomo_1_19_26;
      };
    })
  ];
}
