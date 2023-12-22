{ pkgs, ... }: {
  users.users.sapphiccode = {
    isNormalUser = true;
    description = "Cassandra";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$hmGf7F7DO5k6E9IbH/dTN.$gvp63YhpxwQrbGCfoRgGw7NGdUplN2gRqbsO5ANDSo3";
  };
  programs.fish.enable = true;
}
