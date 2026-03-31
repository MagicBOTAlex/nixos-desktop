{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
(symlinkJoin {
    name = "kicad";
    paths = [kicad];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/kicad \
        --set GDK_BACKEND x11
    '';
  })
    ];
  }
