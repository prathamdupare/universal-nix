{
  description = "Pratham's Multi-OS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # --- Bring over your NixOS inputs ---
    vicinae.url = "github:vicinaehq/vicinae";
    nixvim.url = "github:nix-community/nixvim";
    hyprland.url = "github:hyprwm/hyprland?ref=v0.36.0";
    # Add your other inputs (quickshell, rose-pine, etc.) here
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }: {
    
    # -----------------------------------
    # 1. macOS Mac Mini
    # -----------------------------------
    darwinConfigurations."Prathams-Mac-mini" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        ./mac-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.pratham = import ./home.nix;
        }
      ];
    };

    # -----------------------------------
    # 2. NixOS Laptop
    # -----------------------------------
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.nixvim.nixosModules.nixvim
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.pratham = import ./home.nix;
        }
      ];
    };

  };
}
