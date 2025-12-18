{ pkgs, lib, ... }: {
  services.ollama = {
    host = "0.0.0.0";
    enable = true;
    package = pkgs.ollama-cuda;


  };
}
