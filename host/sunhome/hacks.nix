{...}: {
  systemd.mounts = [
    {
      description = "mount ryujinx bis to windows apps";
      what = "/magpie/media/Games/Sync/Save/Ryujinx/bis";
      where = "/magpie/media/Games/Sync/Windows/Apps/Emulators/ryujinx/portable/bis";
      type = "none";
      options = "bind";
      wantedBy = ["magpie.target"];
    }
    {
      description = "mount ryujinx system to windows apps";
      what = "/magpie/media/Games/Sync/Save/Ryujinx/system";
      where = "/magpie/media/Games/Sync/Windows/Apps/Emulators/ryujinx/portable/system";
      type = "none";
      options = "bind";
      wantedBy = ["magpie.target"];
    }
  ];
}
