{
  description = "The Commune's NixOS / whatever flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

  inputs.quadlet = {
    url = "github:SEIAROTg/quadlet-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    quadlet,
  }: let
    unstable = import nixpkgs-unstable {
      config.allowUnfree = true;
      system = "x86_64-linux";
    };
  in {
    nixosModules = {
      sunhome = [
        ./host/sunhome
        quadlet.nixosModules.quadlet
      ];
    };
    nixosConfigurations = {
      sunhome = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit unstable;};
        modules = [
          ./host/sunhome
          ./host/sunhome/hardware-configuration.nix
          quadlet.nixosModules.quadlet
        ];
      };
    };
  };
}
