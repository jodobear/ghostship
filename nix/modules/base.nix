{pkgs, ...}: {
  networking = {
    firewall.enable = true;
    useDHCP = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.openssh.enable = false;

  users.users.ghostship = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    jq
  ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "26.05";
}
