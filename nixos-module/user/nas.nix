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
  };
  programs.fish.enable = true;
}
