{ pkgs, lib, ... }:

{
  home.username = "pratham";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/pratham" else "/home/pratham";

  home.packages = with pkgs; [
    # Shared CLI tools
    git
    tmux
    ripgrep
    fd
    lazygit
    bun
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Packages ONLY for your NixOS machine
    wl-clipboard
    pavucontrol
    brightnessctl
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # Packages ONLY for your Mac
    # (e.g., raycast, aerospace)
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      # Context-aware update command
      update = if pkgs.stdenv.isDarwin 
               then "darwin-rebuild switch --flake .#Prathams-Mac-mini" 
               else "sudo nixos-rebuild switch --flake .";
    };
  };

  home.stateVersion = "24.11";
}
