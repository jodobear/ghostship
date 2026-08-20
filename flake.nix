{
  description = "Ghostship NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Official Buzz source. Packaging lives here because upstream no longer
    # ships a Nix flake or NixOS module.
    buzz-src = {
      url = "github:block/buzz/e5d1dfef7bf24ad527c9c8c1785b613abad574f7";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    buzz-src,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    ghostshipVm = lib.nixosSystem {
      inherit system;
      modules = [./nix/hosts/vm.nix];
    };
    buzzRelay = pkgs.callPackage ./nix/packages/buzz-relay.nix {
      src = buzz-src;
    };
  in {
    nixosConfigurations.ghostship-vm = ghostshipVm;

    packages.${system} = {
      default = ghostshipVm.config.system.build.vm;
      buzz-relay = buzzRelay;
    };

    checks.${system} = {
      vm-system = ghostshipVm.config.system.build.toplevel;
      buzz-relay = buzzRelay;

      buzz-relay-binaries = pkgs.runCommand "buzz-relay-binaries" {} ''
        for binary in buzz-relay buzz-admin buzz-pair-relay; do
          test -x ${buzzRelay}/bin/$binary
        done
        touch "$out"
      '';

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
