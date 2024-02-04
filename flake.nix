{
  description = "The Commune's NixOS / whatever flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  inputs.quadlet = {
    url = "github:SEIAROTg/quadlet-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, quadlet }: {
    nixosModules = {
      sunhome = [
        ./host/sunhome
        quadlet.nixosModules.quadlet
      ];
    };
    nixosConfigurations = {
      sunhome = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/sunhome
          ./host/sunhome/hardware-configuration.nix
          quadlet.nixosModules.quadlet
        ];
      };
    };
  };
}
