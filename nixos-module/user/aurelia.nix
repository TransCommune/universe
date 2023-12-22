{ pkgs, ... }: {
  users.users.aurelia = {
    isNormalUser = true;
    description = "Aurelia";
    shell = pkgs.fish;
    extraGroups = ["wheel"];
  };
  programs.fish.enable = true;
}
