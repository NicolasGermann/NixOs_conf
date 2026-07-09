{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgsus.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    xremap-flake.url = "github:xremap/nix-flake";
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsus = inputs.nixpkgsus.legacyPackages.${system};
      cfg = builtins.fromTOML (builtins.readFile ./packages.toml);
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        
        specialArgs = {
          inherit inputs;
        };
        
        modules = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix

        ({config, pkgs, ...}: {
          services.flatpak.remotes = [{
            name = "flathub";
            location = "ttps://dl.flathub.org/repo/flathub.flatpakrepo";
          }];

          services.flatpak.packages = cfg.flatpaks;
        })
       ];   
      };
   };
}
