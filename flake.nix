{
  description = "Pratham's Multi-OS Configuration";

  inputs = {
    # Core OS Inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Kept for your workflow
    
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Your Custom Inputs
    vicinae.url = "github:vicinaehq/vicinae";
    devenv.url = "github:cachix/devenv/latest";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs/stable";
    
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland?ref=v0.36.0";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-snapd, ... }: {
    
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
        inputs.nix-snapd.nixosModules.default # FIXED: Added back snapd module
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
