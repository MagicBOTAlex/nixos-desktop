{ pkgs, ... }: {
  programs.ydotool.enable = true;
  users.users = {
    botmain = {
      extraGroups = [ "uinput" "ydotool" ];
    };
  };
  security.sudo.extraRules = [
    {
      users = [ "botmain" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/ydotool";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  environment.variables.YDOTOOL_SOCKET = "/run/ydotoold/socket";
}
