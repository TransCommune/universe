{
  pkgs,
  lib,
  ...
}: let
  zfsPackage = pkgs.zfs_2_3;
in {
  # Target that other services can depend on to ensure magpie pool is mounted
  systemd.targets.magpie = {
    description = "The ZFS NAS mount";
    requires = ["zfs-import-magpie.service"];
    after = ["zfs-import-magpie.service" "zfs-mount.service"];
  };

  boot.initrd.systemd.services.zfs-import-sunhome = {
    after = ["systemd-cryptsetup@luks\\x2droot.service"];
    requires = ["systemd-cryptsetup@luks\\x2droot.service"];
  };

  boot.zfs = {
    package = zfsPackage;
    forceImportRoot = false;
    extraPools = ["magpie"];
  };
  boot.kernelParams = [
    "zfs.zfs_arc_max=8589934592" # 8 GiB
  ];

  boot.supportedFilesystems = ["zfs"];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
    autoSnapshot = {
      enable = true;
      weekly = 0;
      monthly = 0;
      daily = 7;
    };
  };
}
