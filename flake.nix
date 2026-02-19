{
  description = "ramus - nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, noctalia, quickshell, ... }@inputs: {
    nixosConfigurations.ramus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # inputs to configuration.nix
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager 
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lucas = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
