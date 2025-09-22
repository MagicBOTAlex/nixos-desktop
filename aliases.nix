{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    shellAliases = {
      nrb =
        "sudo nixos-rebuild switch --flake /etc/nixos --impure  --fallback && fish";
      nrbs =
        "sudo nixos-rebuild switch --flake /etc/nixos --impure --fallback -j 1 && fish";
      nrbr = "nrb && sudo reboot now";
      ni = "nvim /etc/nixos/configuration.nix";
      bat =
        "upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E 'state|percentage'";
      gpu = "nvidia-smi -q | grep -i 'draw.*W'";
      wifi = "sudo nmtui";
      all = "sudo chmod -R a+rwx ./*";
      ng = "cd /etc/nginx/ && sudo nvim .";
      copy = "xclip -sel clip";
      pubkey = "cat ~/.ssh/id_ed25519.pub | wl-copy";
      up = "docker compose up -d";
      down = "docker compose down";
      server = "ssh botserver@192.168.50.82";
      lap = "ssh botlap@192.168.50.144";
      vpnup = "sudo systemctl start openvpn-work.service";
      vpndown = "sudo systemctl stop openvpn-work.service";
      inspect = "nix edit nixpkgs#$1";
      fe = "nix develop";
      fed = "nvim flake.nix";
      cdn = "cd /etc/nixos";
      cpu =
        "sudo turbostat --quiet --show PkgWatt --interval 1 --num_iterations 1 | awk 'NR==2{print $1}'";
      vr = "~/Desktop/startvr.sh";
    };

    interactiveShellInit = ''
      function enter
        if test (count $argv) -lt 1
          echo "usage: enter <container-name-or-id>"
            return 1
        end
        docker exec -it $argv[1] sh
      end
      function inspect
        if test (count $argv) -lt 1
          echo "usage: inspect <package name>"
            return 1
        end
        nix edit "nixpkgs#$argv[1]"
      end
    '';
  };
}
