# universal-nix

My declarative Nix config. Currently working on NixOS, nix-darwin (macOS), and
tested on Arch Linux (standalone Home Manager).

## Layout

- `flake.nix` — flake entry point with all inputs and the three target configs
- `configuration.nix` + `hardware-configuration.nix` — NixOS system config
- `mac-configuration.nix` — nix-darwin config for the Mac Mini
- `home.nix` — shared Home Manager config (user packages, shell, etc.)
- `modules/`
  - `nixvim/` — Neovim config (Nixvim)
  - `kubernetes/` — Kubernetes tooling
  - `snap/` — snapd helpers

## Targets

- **NixOS laptop** — `nixosConfigurations.nixos`
- **macOS (Mac Mini)** — `darwinConfigurations.Prathams-Mac-mini`
- **Standalone Home Manager (Arch / any Linux)** — `homeConfigurations.pratham`

## Prerequisites

- Nix with flakes enabled (`nix.settings.experimental-features = "nix-command flakes"`)
- On NixOS: just clone and go
- On macOS: [nix-darwin](https://github.com/LnL7/nix-darwin) installed
- On Arch / other Linux: [Home Manager](https://github.com/nix-community/home-manager) installed standalone

## Apply / rebuild

A `update` shell alias is set up per system:

| System | Command |
| --- | --- |
| NixOS | `sudo nixos-rebuild switch --flake .#nixos` |
| macOS | `darwin-rebuild switch --flake .#Prathams-Mac-mini` |
| Standalone HM (Arch) | `home-manager switch -b backup --flake .#pratham` |

So on any system, just run `update` from inside the repo.

### Manual equivalents

```sh
# NixOS
sudo nixos-rebuild switch --flake .#nixos

# macOS
darwin-rebuild switch --flake .#Prathams-Mac-mini

# Standalone Home Manager (Arch / any Linux)
home-manager switch --flake .#pratham
```

### Other useful variants

```sh
# Build without switching (dry run)
nixos-rebuild build --flake .#nixos
darwin-rebuild build --flake .#Prathams-Mac-mini
home-manager build --flake .#pratham

# Update all flake inputs first
nix flake update
# or for a specific input
nix flake update nixpkgs

# Try a config in a temp shell (great for testing changes)
nix develop

# Run a single binary from a flake output (e.g. nixvim)
nix run .#nixvim

# Roll back to the previous generation
nixos-rebuild switch --rollback
darwin-rebuild switch --rollback
home-manager switch --rollback
```

## First-time setup

```sh
git clone <this-repo> ~/git/universal-nix
cd ~/git/universal-nix

# NixOS
sudo nixos-rebuild switch --flake .#nixos

# macOS
darwin-rebuild switch --flake .#Prathams-Mac-mini

# Arch / standalone Home Manager
home-manager switch --flake .#pratham
```
