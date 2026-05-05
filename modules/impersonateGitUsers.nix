{ config, pkgs, ... }:

let
  impersonationList = [ "kaitlyn" "laibah" "alex" "abdulla" ];
in
{
  users.groups.projects = { };

  # 1. Create the users
  users.users = builtins.listToAttrs (map
    (name: {
      name = name;
      value = {
        isNormalUser = true;
        shell = pkgs.fish;
        initialPassword = "1111";
        extraGroups = [ "networkmanager" "projects" ];
      };
    })
    impersonationList);

  # 2. Enable Fish and create the aliases
  programs.fish = {
    shellAliases = builtins.listToAttrs (map
      (name: {
        name = name; # The command you type (e.g., 'kaitlyn')
        value = "su - ${name}"; # The command that executes
      })
      impersonationList);
  };
}
