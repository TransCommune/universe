{ ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix

    ../../nixos-module/user/aurelia.nix
    ../../nixos-module/user/cassandra.nix

    ../../nixos-module/openssh.nix

    ./zfs.nix
    ./samba.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sunhome";
  networking.hostId = "7021b014";

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;

  system.stateVersion = "23.11";
}
