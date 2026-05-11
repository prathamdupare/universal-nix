{ config
, pkgs
, lib 
, ...
}: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins.nix
  ];

  programs.nixvim = {    
    enable = true;
    colorschemes.tokyonight.enable = true;
    globals.mapleader = " ";
    clipboard = {
      providers = {
        # Only enable wl-copy if we are on Linux
        wl-copy.enable = pkgs.stdenv.isLinux; 
      };
      register = "unnamedplus";
    };
  };
}
