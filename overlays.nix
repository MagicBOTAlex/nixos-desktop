flake-overlays:
{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev:
      {
        # Your own overlays...
      })
  ] ++ flake-overlays;
}
