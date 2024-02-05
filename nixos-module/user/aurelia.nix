{ pkgs, ... }: {
  users.users.aurelia = {
    isNormalUser = true;
    description = "Aurelia";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "qemu-libvirtd" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmjGIsSO9jE85xNPzzp0AWfOSXVL4qQ3cuXeKCvxe+q" ];
  };
  programs.fish.enable = true;
}
