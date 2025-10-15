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
      up = "docker compose up -d -t 2";
      down = "docker compose down";
      server = "ssh botserver@192.168.50.82";
      lap = "ssh botlap@192.168.50.144";
      vpnup = "sudo systemctl start openvpn-work.service";
      vpndown = "sudo systemctl stop openvpn-work.service";
      inspect = "nix edit nixpkgs#$1";
      fe = "nix develop";
      fed = "nvim flake.nix";
      r = "nix run";
      cdn = "cd /etc/nixos";
      cpu =
        "sudo turbostat --quiet --show PkgWatt --interval 1 --num_iterations 1 | awk 'NR==2{print $1}'";
      vr = "~/Desktop/startvr.sh";
      dm = "sudo systemctl start display-manager.service";
      tty = "powerprofilesctl set power-saver && sudo systemctl stop display-manager.service";
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
      function plasma-check
        set -l before (mktemp -t rc2nix_before.XXXXXX)
        set -l after  (mktemp -t rc2nix_after.XXXXXX)

        # 1) snapshot current state
        rc2nix > $before

        # 2) wait for user to tweak Plasma settings
        read -n 1 -P "Make your Plasma change, then press any key… "

        # 3) snapshot again
        rc2nix > $after

        # 4) show unified diff
        echo "=== Diff (before → after) ==="
        diff -u --label before --label after $before $after

        # 5) extract relevant added lines, trim '+', trim leading spaces
        set -l relevant (diff -u $before $after | awk '
          /^(\+\+\+|---|@@)/ {next}
          /^[+][^+]/ {
            sub(/^[+]/,""); sub(/^[[:space:]]+/,""); print
          }' | string collect)

        if test -n "$relevant"
          echo "=== Copied to clipboard ==="
          printf "%s\n" "$relevant"
          printf "%s" "$relevant" | wl-copy
        else
          echo "No relevant additions found."
        end

        rm -f $before $after
      end

      function boost
        powerprofilesctl set performance
        sudo cpupower frequency-set -u 5.0GHz
        sudo systemctl stop xmrig
        sudo systemctl stop monero
        sudo systemctl stop p2pool
      end
      function mine
        sudo systemctl start monero
        sudo systemctl start p2pool
        sudo systemctl start xmrig
        powerprofilesctl set power-saver
        sudo cpupower frequency-set -u 3.0GHz
      end
    '';
  };
}
