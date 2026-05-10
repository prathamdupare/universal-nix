{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # We are moving nixvim to home.nix, so we don't import it here anymore
  ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "uinput" ];
  boot.kernelParams = [ "tsc=unstable" "pci=realloc" "pci=nocrs" "video=efifb:off" ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/0933c0c6-3e64-42b2-ae9f-a8d5497ed3d5"; # Double check this UUID from hardware-config
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

  # Users & Shell
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
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  # Hardware (AMD Integrated)
  hardware.graphics = { enable = true; enable32Bit = true; };
  hardware.uinput.enable = true;
  hardware.bluetooth.enable = true;

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    glibc libgcc killall udiskie mpc jmtpfs vulkan-tools pciutils greetd.tuigreet
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11"; 
}
