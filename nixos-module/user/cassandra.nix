{ pkgs, ... }: {
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
