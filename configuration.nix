{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "uinput" ];
  boot.kernelParams = [ "tsc=unstable" "pci=realloc" "pci=nocrs" "video=efifb:off" ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/CACCD7B9CCD79DCF";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=1000" "nofail" "windows_names" ];
  };

  # Core Services
  programs.kdeconnect.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
  services.blueman.enable = true;
  services.tailscale.enable = true;
  
  services.greetd = {
    enable = true;
    settings.default_session = { command = "Hyprland"; user = "pratham"; };
  };
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Hardware (AMD Integrated)
  hardware.graphics = { enable = true; enable32Bit = true; };
  hardware.uinput.enable = true;
  hardware.bluetooth.enable = true;
  services.udev.extraRules = ''KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'';

  # Users & Virtualization
  users.groups.uinput = { };
  systemd.services.kanata-internalKeyboard.serviceConfig = { SupplementaryGroups = [ "input" "uinput" ]; };
  virtualisation.docker = { enable = true; enableOnBoot = false; };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.pratham = {
    isNormalUser = true;
    description = "Pratham";
    extraGroups = [ "networkmanager" "wheel" "docker" "uinput" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Networking & Locale
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.extraHosts = ''127.0.0.1 screenshot.local'';
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedTCPPorts = [ 30000 ];
  networking.firewall.allowedUDPPorts = [ 30000 ];
  systemd.services.NetworkManager-wait-online.enable = false;
  
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN"; LC_IDENTIFICATION = "en_IN"; LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN"; LC_NAME = "en_IN"; LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN"; LC_TELEPHONE = "en_IN"; LC_TIME = "en_IN";
  };

  # Hyprland & Wayland Env
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprlock.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Missing Fonts & Dconf restored
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];

  # Extra Programs
  programs.nix-ld.enable = true;
  services.flatpak.enable = true;
  services.snap.enable = false;
  security.rtkit.enable = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    glibc libgcc killall udiskie mpc jmtpfs vulkan-tools pciutils greetd.tuigreet 
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    chromedriver
    android-tools
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

  system.stateVersion = "24.11"; 
}
