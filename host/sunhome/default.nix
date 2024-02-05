{ pkgs, config, ... }: {
  imports = [
    ../../nixos-module/user/aurelia.nix
    ../../nixos-module/user/cassandra.nix

    ../../nixos-module/openssh.nix

    ./zfs.nix
    ./samba.nix
    ./libvirt.nix

    ./container/unifi.nix
    ./container/homeassistant.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-root".device = "/dev/nvme0n1p2";
  boot.zfs.forceImportRoot = false;
  boot.initrd.systemd.enable = true;

  # fix for crappy Intel 2.5GbE
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.hostName = "sunhome";
  networking.hostId = "5ffb3d23";

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.enable = false; # required for HomeKit

  security.sudo.wheelNeedsPassword = false;

  virtualisation.podman.enable = true;

  system.stateVersion = "23.11";
}
