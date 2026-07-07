{ pkgs, lib, inputs, standalone ? false, ... }:

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
    git tmux ripgrep fd lazygit bun nodejs_22 go gcc gnumake unzip yazi  fastfetch vim
    atool httpie lua yarn
  ] ++ lib.optionals (pkgs.stdenv.isLinux && !standalone) [
    # NixOS Only Tools
    wl-clipboard pavucontrol brightnessctl brave gimp yt-dlp nicotine-plus nautilus 
    android-studio jdk17 blender mpv kitty foot xdg-desktop-portal-hyprland ghostty 
    waybar wofi swaybg mako pywal libnotify hyprlock hypridle bluetuith alsa-utils
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd=cd" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = if standalone
               then "home-manager switch -b backup --flake .#pratham"
               else if pkgs.stdenv.isDarwin 
               then "darwin-rebuild switch --flake .#Prathams-Mac-mini" 
               else "sudo nixos-rebuild switch --flake .#nixos";
    };
    envExtra = ''
      export PATH=/home/pratham/.opencode/bin:$PATH
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "vi-mode" "zsh-history-substring-search" ];
    };
  };

  services.vicinae = lib.mkIf (pkgs.stdenv.isLinux && !standalone) {
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

  services.mpd = lib.mkIf (pkgs.stdenv.isLinux && !standalone) {
    enable = true;
    musicDirectory = "/home/pratham/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
          name "PipeWire"
      }
    '';
  };

  # Hourly reminder (9am-9pm) to check tasks/notes via notify-send
  systemd.user.services.notes-reminder = lib.mkIf pkgs.stdenv.isLinux {
    Unit = { Description = "Notes & tasks reminder"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.libnotify}/bin/notify-send --icon=task-due --urgency=normal 'Tasks reminder' 'Check your notes ~/git/notes/TODO.md'";
    };
  };
  systemd.user.timers.notes-reminder = lib.mkIf pkgs.stdenv.isLinux {
    Unit.Description = "Hourly notes/tasks reminder (9am-9pm)";
    Timer = {
      OnCalendar = "*-*-* 09..21:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  home.stateVersion = "25.11";
}
