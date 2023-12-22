{ pkgs, ... }:
let
  requiredMounts = [
    # samba
    "magpie-media.mount"
    "magpie-aurelia-scratch.mount"
    "magpie-aurelia-macrium.mount"
    "magpie-aurelia-tm\\x2dpersonal.mount"
    "magpie-phoenix-personal.mount"

    # containers
    "magpie-apps-photoprism.mount"
    "magpie-apps-seafile.mount"
  ];
in
{
  systemd.targets.magpie = {
    description = "The ZFS NAS mount";
    requires = requiredMounts;
    after = requiredMounts;
  };

  systemd.services.zfs-import = {
    description = "Imports all available ZFS pools.";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
    };

    path = with pkgs; [ zfs ];
    script = ''
      #!/usr/bin/env bash

      set -eux -o pipefail

      zpool import -a
      zfs load-key -ar
    '';
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
  };
}
