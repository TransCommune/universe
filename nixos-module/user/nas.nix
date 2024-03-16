{
  pkgs,
  config,
  ...
}: {
  users.groups.nas = {
    gid = 992;
    name = "nas";
  };
  users.users.nas = {
    description = "NAS file owner and script runner";

    uid = 994;
    name = "nas";
    group = config.users.groups.nas.name;

    isSystemUser = true;

    createHome = true;
    home = "/home/nas";

    shell = pkgs.fish;
    packages = with pkgs; [
      nushell
      rclone
      restic
      yt-dlp
      ffmpeg
      exiftool
    ];
  };
  programs.fish.enable = true;
}
