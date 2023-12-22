{ pkgs, ... }: {
  users.users.aurelia = {
    isNormalUser = true;
    description = "Aurelia";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
