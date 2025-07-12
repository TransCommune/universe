{...}: let
  bindMount = what: where: {
    description = "mount ${what} to ${where}";
    what = what;
    where = where;
    type = "none";
    options = "bind";
    wantedBy = ["magpie-media-bindmounts.target"];
    bindsTo = ["magpie-media-bindmounts.target"];
  };
  bindMountRetroDeckROM = type: (bindMount "/magpie/media/Games/ActiveLibrary/roms/${type}" "/magpie/media/Games/Sync/RetroDeck/roms/${type}");
in {
  services.syncthing = {
    after = ["magpie-media-bindmounts.target"];
    requires = ["magpie-media-bindmounts.target"];
  };

  systemd.targets.magpie-media-bindmounts = {
    description = "The ZFS NAS mount";
    requires = ["magpie.target"];
  };
  systemd.mounts = [
    (bindMountRetroDeckROM "dreamcast")
    (bindMountRetroDeckROM "easyrpg")
    (bindMountRetroDeckROM "gb")
    (bindMountRetroDeckROM "gba")
    (bindMountRetroDeckROM "gbc")
    (bindMountRetroDeckROM "gc")
    (bindMountRetroDeckROM "megadrive")
    (bindMountRetroDeckROM "model2")
    (bindMountRetroDeckROM "n3ds")
    (bindMountRetroDeckROM "n64")
    (bindMountRetroDeckROM "nds")
    (bindMountRetroDeckROM "nes")
    (bindMountRetroDeckROM "pcengine")
    (bindMountRetroDeckROM "ps2")
    (bindMountRetroDeckROM "ps3")
    (bindMountRetroDeckROM "psp")
    (bindMountRetroDeckROM "psvita")
    (bindMountRetroDeckROM "psx")
    (bindMountRetroDeckROM "snes")
    (bindMountRetroDeckROM "switch")
    (bindMountRetroDeckROM "wii")
    (bindMountRetroDeckROM "wiiu")
    (bindMountRetroDeckROM "xbox360")
  ];

  services.syncthing = {
    enable = true;
    user = "nas";
    group = "nas";
    openDefaultPorts = true;
    extraFlags = [
      "--gui-address=100.84.223.80:8384"
    ];
    configDir = "/home/nas/.config/syncthing";
    dataDir = "/home/nas";
  };
}
