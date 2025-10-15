{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "gminer";
  version = "3.44"; # bump as needed

  src = fetchzip {
    url = "https://github.com/develsoftware/GMinerRelease/releases/download/${version}/gminer_${builtins.replaceStrings ["."] ["_"] version}_linux64.tar.xz";
    hash = "sha256-OlkDQje7vIzNzvQ5iI1fmxAJJfKvPBqvxM6YvjnBqgE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/doc/gminer

    # If the archive has a top-level dir, cd into it
    top="$(echo gminer_*_linux64 || true)"
    if [ -d "$top" ]; then cd "$top"; fi

    # Install binary as `gminer` (upstream binary is usually `miner`)
    if [ -x miner ]; then
      install -m755 miner $out/bin/gminer
    else
      # fallback: first executable file in dir
      exe="$(find . -maxdepth 1 -type f -perm -111 | head -n1)"
      install -m755 "$exe" $out/bin/gminer
    fi

    # keep the rest as docs/examples
    cp -r . $out/share/doc/gminer/ || true
    runHook postInstall
  '';

  meta = {
    description = "GMiner GPU miner";
    homepage = "https://github.com/develsoftware/GMinerRelease";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}


