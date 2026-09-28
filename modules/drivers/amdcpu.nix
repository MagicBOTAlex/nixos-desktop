{
  config,
  pkgs,
  lib,
  ...
}:

{
  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    # Load amdgpu during initrd for early KMS (Kernel Mode Setting)
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "kvm-amd"
      "amdgpu"
      "k10temp"
    ];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "amd_pstate=disactive"
    ];
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  # Graphics & Hardware Acceleration (Mesa, VA-API, VDPAU)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit apps like Steam / Wine
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      # rocmPackages.clr.icd # Uncomment if you need OpenCL compute (Blender/Darktable)
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Monitoring & GPU management tools
  environment.systemPackages = with pkgs; [
    ryzenadj
    zenmonitor
    lm_sensors
    corectrl
    clinfo # Query OpenCL support
    vulkan-tools # Provides vkcube to test Vulkan
    libva-utils # Provides vainfo to verify VA-API video decoding
  ];

  # Optional: CoreCtrl permission settings for full AMD GPU control
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  # thermald is an Intel-only daemon — disable or remove it for AMD
  services.thermald.enable = false;
}
