{modulesPath, ...}: {
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
    ../modules/base.nix
  ];

  networking.hostName = "ghostship-vm";

  virtualisation = {
    cores = 2;
    memorySize = 8192;
    diskSize = 102400;
    graphics = false;
  };
}
