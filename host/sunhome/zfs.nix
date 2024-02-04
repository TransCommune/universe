{ pkgs, ... }:
{
  systemd.targets.magpie = {
    description = "The ZFS NAS mount";
    requires = [ "zfs-import-all.service" ];
  };

  systemd.services."zfs-import-all" = {
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      set -eux -o pipefail
      ${pkgs.zfs}/bin/zpool import -a
      ${pkgs.zfs}/bin/zfs load-key -a
      ${pkgs.zfs}/bin/zfs mount -a
    '';
  };

  boot.supportedFilesystems = [ "zfs" ];
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
  };
}
