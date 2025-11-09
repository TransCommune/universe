{...}: let
  bindMount = what: where: ro: {
    description = "mount ${what} to ${where}";
    what = what;
    where = where;
    type = "none";
    options =
      if ro
      then "bind,ro"
      else "bind";
    wantedBy = ["magpie-media-bindmounts.target"];
    bindsTo = ["magpie-media-bindmounts.target"];
    after = ["magpie.target"];
  };
  activeLibraryDir = "/magpie/media/Games/ActiveLibrary";
  retroDeckDir = "/magpie/media/Games/Sync/RetroDeck";
  androidDir = "/magpie/media/Games/Sync/Android";
  bindMountRetroDeckROM = type: (bindMount "${activeLibraryDir}/roms/${type}" "${retroDeckDir}/roms/${type}" true);
  bindMountRetroDeckSave = type: (bindMount "${activeLibraryDir}/saves/${type}" "${retroDeckDir}/saves/${type}" false);
  bindMountAndroidROM = type: (bindMount "${activeLibraryDir}/roms/${type}" "${androidDir}/roms/${type}" true);
  bindMountAndroidSave = type: (bindMount "${activeLibraryDir}/saves/${type}" "${androidDir}/saves/${type}" false);
in {
  systemd.services.syncthing = {
    after = ["magpie-media-bindmounts.target"];
    requires = ["magpie-media-bindmounts.target"];
  };

  systemd.targets.magpie-media-bindmounts = {
    description = "The ZFS NAS mount";
    requires = ["magpie.target"];
  };
  systemd.mounts = [
    (bindMount "${activeLibraryDir}/bios" "${retroDeckDir}/bios" true)
    (bindMountRetroDeckROM "dreamcast")
    (bindMountRetroDeckROM "easyrpg")
    (bindMountRetroDeckROM "gb")
    (bindMountRetroDeckROM "gba")
    (bindMountRetroDeckROM "gbah")
    (bindMountRetroDeckROM "gbc")
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

    (bindMountRetroDeckSave "gb")
    (bindMountRetroDeckSave "gbc")
    (bindMountRetroDeckSave "gba")
    (bindMountRetroDeckSave "gc")
    (bindMountRetroDeckSave "nds")

    (bindMountAndroidROM "dreamcast")
    (bindMountAndroidROM "gb")
    (bindMountAndroidROM "gba")
    (bindMountAndroidROM "gbah")
    (bindMountAndroidROM "gbc")
    (bindMountAndroidROM "gc")
    (bindMountAndroidROM "n3ds")
    (bindMountAndroidROM "n64")
    (bindMountAndroidROM "nds")
    (bindMountAndroidROM "nes")
    (bindMountAndroidROM "pcengine")
    (bindMountAndroidROM "ps2")
    (bindMountAndroidROM "ps3")
    (bindMountAndroidROM "psp")
    (bindMountAndroidROM "psvita")
    (bindMountAndroidROM "psx")
    (bindMountAndroidROM "snes")
    (bindMountAndroidROM "switch")
    (bindMountAndroidROM "wii")
    (bindMountAndroidROM "wiiu")
    (bindMountAndroidROM "xbox360")

    (bindMountAndroidSave "gb")
    (bindMountAndroidSave "gbc")
    (bindMountAndroidSave "gba")
    (bindMountAndroidSave "nds")

    (bindMount "${activeLibraryDir}/custom_data/azahar" "${retroDeckDir}/custom_data/azahar" false)
    (bindMount "${activeLibraryDir}/custom_data/dolphin" "${retroDeckDir}/custom_data/dolphin" false)
    (bindMount "${activeLibraryDir}/custom_data/eden" "${retroDeckDir}/custom_data/eden" false)
    (bindMount "${activeLibraryDir}/custom_data/ryujinx" "${retroDeckDir}/custom_data/ryujinx" false)
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
