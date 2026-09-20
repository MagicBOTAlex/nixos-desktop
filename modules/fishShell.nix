{pkgs, ...} : {
  programs.fish.enable = true;
  documentation.man.cache.enable = false;

  users.users."botmain".shell = pkgs.fish;
}
