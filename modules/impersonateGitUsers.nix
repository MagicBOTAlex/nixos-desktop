{ config, pkgs, ... }:

let
  impersonationList = [
    "kaitlyn"
    "laibah"
    "alex"
    "abdulla"
    "thomas"
  ];
in
{
  users.groups.projects = { };

  # 1. Create the users
  users.users = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        isNormalUser = true;
        shell = pkgs.fish;
        initialPassword = "1111";
        extraGroups = [
          "networkmanager"
          "projects"
        ];
      };
    }) impersonationList
  );

  # 2. Enable Fish and create the aliases
  programs.fish = {
    shellAliases = builtins.listToAttrs (
      map (name: {
        name = name; # The command you type (e.g., 'kaitlyn')
        value = "su - ${name}"; # The command that executes
      }) impersonationList
    );
  };

  systemd.tmpfiles.rules = [
    # Type  Path                                         Mode  User     Group     Age  Argument
    # NOTE: the recursive "Z" rule used to live here, but it chmod'd ~400k files
    # in /home/botmain/Desktop/projects/school on *every* boot (~5s of boot time).
    # Existing files are fixed once by school-permissions.service below; new files
    # inherit the group via the setgid bit + default ACL set here.
    "d      /home/botmain/Desktop/projects/school        2775  botmain  projects  -    -"
    "a+ /home/botmain/Desktop/projects/school - - - - default:group:projects:rwx"
  ];

  # One-time recursive fixup, skipped once the stamp exists.
  # To re-run after moving files in: rm /var/lib/school-permissions.done
  systemd.services.school-permissions = {
    description = "Fix school projects group permissions (one-time)";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    unitConfig.ConditionPathExists = "!/var/lib/school-permissions.done";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      chown -R botmain:projects /home/botmain/Desktop/projects/school
      chmod -R u=rwX,g=rwX,o=rX /home/botmain/Desktop/projects/school
      chmod g+s /home/botmain/Desktop/projects/school
      mkdir -p /var/lib
      touch /var/lib/school-permissions.done
    '';
  };
}
