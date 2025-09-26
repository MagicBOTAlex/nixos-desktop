{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.default.settings = {
      "ui.key.menuAccessKeyFocuses" = false;
      "ui.key.menuAccessKey" = 0;
    };
  };

}
