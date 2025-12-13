{ pkgs, lib, ... }:
let toggles = import ./toggles.nix;
in
{
  imports = [
    ./modules/nvim.nix
    ./configs/plasma6.nix
    ./configs/ydotoolShortcuts.nix
    ./homeModules/btop.nix
    ./homeModules/firefox.nix

    # Do not disable under here =========================== Disable in toggles.nix
    ./homeModules/vr.nix
  ] ++ lib.optional (toggles.vscode.enable) ./homeModules/vscode.nix
  ++ lib.optional (toggles.wezterm.enable or false) ./homeModules/wezterm.nix;

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

  fonts.fontconfig = {
    enable = true;
    configFile."no-bitmaps" = {
      enable = true;
      priority = 50;
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="font">
            <edit name="embeddedbitmap" mode="assign">
              <bool>false</bool>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
  home.packages = with pkgs; [
    noto-fonts-cjk-sans # Sans-serif Chinese fonts
    noto-fonts-cjk-serif # Serif Chinese fonts
    wqy_zenhei # Optional: A popular alternative if Noto doesn't work well
  ];
}
