{ pkgs, lib, ... }:
let toggles = import ./toggles.nix;
in {
  imports = [
    ./modules/nvim.nix
    ./configs/plasma6.nix
    ./homeModules/btop.nix

    # Do not disable under here =========================== Disable in toggles.nix
    ./homeModules/vr.nix
  ] ++ lib.optional (toggles.vscode.enable) ./homeModules/vscode.nix;

  # packages only for this user
  home.packages = [ ];

  # env variables for this user
  home.sessionVariables = {
    EDITOR = "nvim"; # use nvim as editor
  };

  home.stateVersion = "25.11";

  # home.file.".local/share/fonts/CozetteVector-nerd.ttf".source =
  #   builtins.fetchurl "https://deprived.dev/assets/CozetteVector-nerd.ttf";

  home.file.".local/share/fonts/CozetteVector-nerd.ttf".source = pkgs.fetchurl {
    url = "https://deprived.dev/assets/CozetteVector-nerd.ttf";
    sha256 = "1xd5yn6czgym6ayp5bb9mj409a4d78839c6cjkky2l2264hc04q1";
  };

  fonts.fontconfig.enable = true;
}
