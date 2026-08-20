{
  description = "Ghostship NixOS infrastructure";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    ghostshipVm = lib.nixosSystem {
      inherit system;
      modules = [./nix/hosts/vm.nix];
    };
  in {
    nixosConfigurations.ghostship-vm = ghostshipVm;

    packages.${system}.default = ghostshipVm.config.system.build.vm;

    checks.${system} = {
      vm-system = ghostshipVm.config.system.build.toplevel;

      vm-boot = pkgs.testers.runNixOSTest {
        name = "ghostship-vm-boot";
        nodes.machine = {lib, ...}: {
          imports = [./nix/hosts/vm.nix];

          # The test driver provides its own boot path and root filesystem.
          boot.loader.grub.enable = lib.mkForce false;
        };
        testScript = ''
          machine.start()
          machine.wait_for_unit("multi-user.target")
          machine.succeed("systemctl is-system-running --wait | grep -E '^(running|degraded)$'")
          machine.succeed("test $(nproc) -eq 2")
          machine.succeed("test $(awk '/MemTotal/ { print int($2 / 1024) }' /proc/meminfo) -ge 7900")
        '';
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
