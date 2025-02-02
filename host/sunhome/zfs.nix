{pkgs, lib, ...}: let
  zfsPackage = pkgs.zfs_2_3;
in {
  systemd.targets.magpie = {
    description = "The ZFS NAS mount";
    requires = ["zfs-import-all.service"];
  };

  systemd.services."zfs-import-all" = {
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      set -eux -o pipefail
      ${zfsPackage}/bin/zpool import -a
      ${zfsPackage}/bin/zfs load-key -a
      ${zfsPackage}/bin/zfs mount -a
    '';
  };

  boot.zfs = {
    enabled = lib.mkForce true;
    package = zfsPackage;
    forceImportRoot = false;
  };
  boot.supportedFilesystems = ["zfs"];
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
  };
}
