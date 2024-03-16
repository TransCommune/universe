{
  pkgs,
  config,
  ...
}: {
  users.groups.nas.name = "nas";
  users.users.nas = {
    description = "NAS file owner and script runner";

    name = "nas";
    group = config.users.groups.nas.name;

    isSystemUser = true;
    createHome = true;

    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
