{
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ../../nixos-module/user/aurelia.nix
    ../../nixos-module/user/cassandra.nix

    ../../nixos-module/openssh.nix
    ../../nixos-module/user/nas.nix

    ./backup.nix
    ./network.nix
    ./zfs.nix

    ./dashboard.nix
    ./samba.nix
    ./libvirt.nix
    ./incus.nix
    ./nginx.nix
    ./wireproxy.nix
    ./observability.nix
    ./attic.nix
    ./paperless.nix
    ./hacks.nix
    ./postgres.nix

    ./container/immich.nix
    ./container/homeassistant.nix
    ./container/rustdesk.nix
    ./container/seafile.nix
    ./container/copyparty.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.cockpit = {
    enable = true;
    openFirewall = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    SDL2
  ];

  environment.systemPackages = with pkgs; [
    btop
    fd
    file
    htop
    nodejs_20
    nsz
    pv
    restic
    smartmontools
    tmux
    yt-dlp
    zellij

    p7zip

    dolphin-emu
    mame.tools
    ctrtool
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-root".device = "/dev/nvme0n1p2";
  boot.initrd.systemd.enable = true;

  # LTS to avoid ZFS breakage
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking.hostName = "sunhome";
  networking.hostId = "5ffb3d23";

  time.timeZone = "UTC";

  zramSwap.enable = true;

  services.tailscale.enable = true;
  services.tailscale.package = unstable.tailscale;
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.enable = false; # required for HomeKit

  security.sudo.wheelNeedsPassword = false;

  virtualisation.podman.enable = true;

  services.jellyfin.enable = true;
  services.jellyfin.group = "nas";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  system.stateVersion = "23.11";
}
