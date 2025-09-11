{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      color_theme = "onedark";
      update_ms = 1000;
      show_cpu_watts = true;
      proc_sorting = "cpu direct";

    };
  };
}
