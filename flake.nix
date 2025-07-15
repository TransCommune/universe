{
  description = "The Commune's NixOS / whatever flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  inputs.constants.url = "github:TransCommune/constants";

  inputs.quadlet.url = "github:SEIAROTg/quadlet-nix";

  inputs.sc = {
    url = "github:SapphicCode/nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    constants,
  }: let
    unstable = import nixpkgs-unstable {
      config.allowUnfree = true;
      system = "x86_64-linux";
    };
  in {
    nixosModules = {
      constants = import ./nixos-module/constants;
    };
    nixosConfigurations = {
      sunhome = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit unstable constants;};
        modules = [
          ./host/sunhome
          ./host/sunhome/hardware-configuration.nix
          inputs.quadlet.nixosModules.quadlet
          inputs.sc.nixosModules.user_automata
        ];
      };
    };
  };
}
