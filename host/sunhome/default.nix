{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../../nixos-module/user/aurelia.nix
    ../../nixos-module/user/cassandra.nix

    ../../nixos-module/openssh.nix
    ../../nixos-module/user/nas.nix

    ./zfs.nix
    ./samba.nix
    ./libvirt.nix
    ./nginx.nix
    ./backup.nix
    ./wireproxy.nix

    ./container/immich.nix
    ./container/unifi.nix
    ./container/homeassistant.nix
    ./container/rustdesk.nix
    ./container/seafile.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.cockpit = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    restic
    tmux
    htop
    btop
    pv
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-root".device = "/dev/nvme0n1p2";
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      # this includes the ssh keys of all users in the wheel group, but you can just specify some keys manually
      # authorizedKeys = [ "ssh-rsa ..." ];
      authorizedKeys = with lib;
        concatLists (mapAttrsToList (name: user:
          if elem "wheel" user.extraGroups
          then user.openssh.authorizedKeys.keys
          else [])
        config.users.users);
      hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key" "/etc/secrets/initrd/ssh_host_ed25519_key"];
    };
    postCommands = ''
      echo 'cryptsetup-askpass' >> /root/.profile
    '';
  };

  boot.zfs.forceImportRoot = false;
  #boot.initrd.systemd.enable = true;

  # fix for crappy Intel 2.5GbE
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  networking.hostName = "sunhome";
  networking.hostId = "5ffb3d23";

  time.timeZone = "UTC";

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.enable = false; # required for HomeKit

  security.sudo.wheelNeedsPassword = false;

  virtualisation.podman.enable = true;

  services.jellyfin.enable = true;
  services.jellyfin.group = "nas";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  services.syncthing = {
    enable = true;
    user = "nas";
    group = "nas";
    openDefaultPorts = true;
    extraFlags = [
      "--gui-address=100.66.158.81:8384"
    ];
    configDir = "/home/nas/.config/syncthing";
    dataDir = "/home/nas";
  };

  system.stateVersion = "23.11";
}
