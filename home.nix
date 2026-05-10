{ pkgs, lib, inputs, ... }:

{
  home.username = "pratham";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/pratham" else "/home/pratham";

  imports = [
    # Sync your Neovim config to both machines
    ./modules/nixvim/defaults.nix 
  ];

  home.packages = with pkgs; [
    # --- Shared (Installs on Mac & Linux) ---
    git tmux ripgrep fd lazygit bun nodejs_22 go gcc gnumake unzip yazi ghostty fastfetch
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # --- Laptop Only ---
    wl-clipboard pavucontrol brightnessctl brave gimp yt-dlp mpv
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      update = if pkgs.stdenv.isDarwin 
               then "darwin-rebuild switch --flake .#Prathams-Mac-mini" 
               else "sudo nixos-rebuild switch --flake .#nixos";
    };
  };

  home.stateVersion = "24.11";
}
