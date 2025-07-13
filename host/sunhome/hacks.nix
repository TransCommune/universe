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
  activeLibraryDir = "/magpie/media/Games/ActiveLibrary";
  retroDeckDir = "/magpie/media/Games/Sync/RetroDeck";
  androidDir = "/magpie/media/Games/Sync/Android";
  bindMountRetroDeckROM = type: (bindMount "${activeLibraryDir}/roms/${type}" "${retroDeckDir}/roms/${type}");
  bindMountRetroDeckSave = type: (bindMount "${activeLibraryDir}/saves/${type}" "${retroDeckDir}/saves/${type}");
  bindMountAndroidROM = type: (bindMount "${activeLibraryDir}/roms/${type}" "${androidDir}/roms/${type}");
  bindMountAndroidSave = type: (bindMount "${activeLibraryDir}/saves/${type}" "${androidDir}/saves/${type}");
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
    (bindMount "${activeLibraryDir}/bios" "${retroDeckDir}/bios")
    (bindMountRetroDeckROM "dreamcast")
    (bindMountRetroDeckROM "easyrpg")
    (bindMountRetroDeckROM "gb")
    (bindMountRetroDeckROM "gba")
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

    #(bindMountAndroidROM "dreamcast")
    (bindMountAndroidROM "gb")
    (bindMountAndroidROM "gba")
    (bindMountAndroidROM "gbc")
    #(bindMountAndroidROM "gc")
    (bindMountAndroidROM "n3ds")
    (bindMountAndroidROM "n64")
    (bindMountAndroidROM "nds")
    (bindMountAndroidROM "nes")
    (bindMountAndroidROM "pcengine")
    #(bindMountAndroidROM "ps2")
    #(bindMountAndroidROM "ps3")
    (bindMountAndroidROM "psp")
    #(bindMountAndroidROM "psvita")
    (bindMountAndroidROM "psx")
    (bindMountAndroidROM "snes")
    #(bindMountAndroidROM "switch")
    #(bindMountAndroidROM "wii")
    #(bindMountAndroidROM "wiiu")
    #(bindMountAndroidROM "xbox360")

    (bindMountAndroidSave "gb")
    (bindMountAndroidSave "gbc")
    (bindMountAndroidSave "gba")
    (bindMountAndroidSave "nds")

    (bindMount "${activeLibraryDir}/custom_data/azahar" "${retroDeckDir}/custom_data/azahar")
    (bindMount "${activeLibraryDir}/custom_data/dolphin" "${retroDeckDir}/custom_data/dolphin")
    (bindMount "${activeLibraryDir}/custom_data/eden" "${retroDeckDir}/custom_data/eden")
    (bindMount "${activeLibraryDir}/custom_data/ryujinx" "${retroDeckDir}/custom_data/ryujinx")
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
