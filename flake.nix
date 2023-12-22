{
  description = "The Commune's NixOS / whatever flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      sunhome = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/sunhome
        ];
      };
    };
  };
}
