{ config, lib, pkgs, inputs, ... }:
let
  modded-oscavmgr = pkgs.oscavmgr.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "MagicBOTAlex";
      repo = "oscavmgr";
      rev = "b455883";
      hash = "sha256-mY2CPtEGktmIlVto/UaNLtRyT9A88cS+KcRYKVlV394=";
    };
  });
  toggles = import ./../toggles.nix;

  steamUser = "botmain"; # Target linux user
  vrPath = "/home/${steamUser}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
in
{

  config = lib.mkIf toggles.vr.enable {
    environment.systemPackages = with pkgs; [
      motoc # Quest to PC tracking calibration
      wlx-overlay-s # Requires "--fallback" in sudo nixos-rebuild switch --flake /etc/nixos --impure  --fallback
      wayvr-dashboard
      # (pkgs.callPackage ./submodules/vrcft.nix { })
      modded-oscavmgr
      vrcadvert
      # inputs.avalonia.packages.x86_64-linux.default
      eepyxr
      bs-manager
      # wivrn
    ];

    programs.adb.enable = true;

    services.wivrn = {
      enable = true;
      openFirewall = true;
      highPriority = true;
      autoStart = true;
      # package = (pkgs.callPackage ./customPackages/wivrn/wivrn.nix { }).overrideAttrs (oldAttrs: {
      package = pkgs.wivrn.overrideAttrs (oldAttrs: {
        cmakeFlags = oldAttrs.cmakeFlags ++ [
          (lib.cmakeBool "WIVRN_FEATURE_DEBUG_GUI" true)
          (lib.cmakeBool "XRT_FEATURE_OPENXR_LAYER_COLOR_SCALE_BIAS" true)
        ];
        buildInputs = oldAttrs.buildInputs ++ [
          pkgs.sdl2-compat
          pkgs.systemd
          #
        ];
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];

        postInstall = (oldAttrs.postInstall or "") + ''
          # Wrap all executables with proper library path
                    for binary in $out/bin/*; do
          if [[ -f "$binary" && -x "$binary" ]]; then
          wrapProgram "$binary" \
          --prefix LD_LIBRARY_PATH : "${
            lib.makeLibraryPath [ pkgs.systemd pkgs.udev ]
          }"
          fi
          done
        '';
      });

      defaultRuntime = true;
    };

    # # Root oneshot that grants CAP_SYS_NICE to vrcompositor-launcher
    # systemd.services.steamvr-cap-sys-nice = {
    #   description = "Grant CAP_SYS_NICE to SteamVR vrcompositor-launcher";
    #   after = [ "local-fs.target" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = "${pkgs.libcap}/bin/setcap CAP_SYS_NICE+eip ${vrPath}";
    #   };
    #   wantedBy = [ "multi-user.target" ];
    # };
    #
    # # Re-run the service whenever the binary appears/changes
    # systemd.paths.steamvr-cap-sys-nice = {
    #   wantedBy = [ "multi-user.target" ];
    #   pathConfig = {
    #     PathExists = vrPath;
    #     PathChanged = vrPath;
    #   };
    # };
  };
}
