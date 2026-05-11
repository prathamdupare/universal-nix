{ config, pkgs, self, ... }:

{
  # Minimal system-wide packages. Most should go in home.nix.
  environment.systemPackages = [ pkgs.vim ];

  nix.enable = true;
  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;
  
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The user account (Ensure this matches your actual macOS shortname)
  users.users.pratham = {
    name = "pratham";
    home = "/Users/pratham";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
