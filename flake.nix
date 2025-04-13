{
  description = "The Commune's NixOS / whatever flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

  inputs.quadlet = {
    url = "github:SEIAROTg/quadlet-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.sc = {
    url = "git+https://git.sapphiccode.net/SapphicCode/universe";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    quadlet,
    sc,
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
          sc.nixosModules.user_automata
        ];
      };
    };
  };
}
