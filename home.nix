{ pkgs, lib, inputs, ... }:

{
  home.username = "pratham";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/pratham" else "/home/pratham";

  # Global unfree permission for Home Manager (Stops plugin license errors)
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim 
    ./modules/nixvim/defaults.nix 
  ];

  home.packages = with pkgs; [
    # Shared CLI tools
    git tmux ripgrep fd lazygit bun nodejs_22 go gcc gnumake unzip yazi ghostty fastfetch vim
    atool httpie lua yarn
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # NixOS Only Tools
    wl-clipboard pavucontrol brightnessctl brave gimp yt-dlp nicotine-plus nautilus 
    android-studio jdk17 blender mpv kitty foot xdg-desktop-portal-hyprland 
    waybar wofi swaybg mako pywal libnotify hyprlock hypridle bluetuith alsa-utils
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = if pkgs.stdenv.isDarwin 
               then "darwin-rebuild switch --flake .#Prathams-Mac-mini" 
               else "sudo nixos-rebuild switch --flake .#nixos";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "vi-mode" "zsh-history-substring-search" ];
    };
  };

  services.vicinae = {
    enable = true;
    settings = {
      theme.name = "tokyo-night";
      font.size = 11;
      faviconService = "twenty";
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      window = { csd = true; opacity = 0.75; rounding = 10; };
    };
  };

  services.mpd = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    musicDirectory = "/home/pratham/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
          name "PipeWire"
      }
    '';
  };

  home.stateVersion = "25.11";
}
