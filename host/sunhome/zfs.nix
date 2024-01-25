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
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
  };
}
