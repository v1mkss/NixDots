# NixOS Configuration

This is my personal NixOS configuration using Flakes and Home Manager.

## Features

- **Desktop Environment**: GNOME (can be switched to KDE in `modules/core/desktop.nix`)
- **Shell**: Fish with custom prompt and utilities
- **Development Tools**:
  - JetBrains Toolbox
  - VSCode
  - Zed Editor
  - Multiple Java versions (8, 11, 17, 21)
  - Rust
  - Bun
- **Applications**:
  - Floorp(Firefox)
  - Telegram
  - Discord (with OpenASAR and Vencord)
  - LibreOffice
  - MPV
  - OBS Studio
  - Spotify

## Structure

```
.
├── flake.nix           # Main flake configuration
├── hosts/
│   └── v1mkss/        # Host-specific configurations
├── modules/
│   ├── core/          # System-wide configurations
│   │   ├── desktop.nix
│   │   ├── fonts.nix
│   │   ├── hardware.nix
│   │   ├── language.nix
│   │   ├── network.nix
│   │   ├── services.nix
│   │   └── users.nix
│   └── home/          # User-specific configurations
│       ├── development.nix
│       ├── fish.nix
│       ├── git.nix
│       └── packages.nix
└── install.sh         # Installation script
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/nixos-config.git
cd nixos-config
```

2. Run the installation script:
```bash
sh ./install.sh
```

The script will:
- Copy your hardware configuration
- Build and switch to the new configuration
- Optionally reboot the system

## Usage

### System Management

- Cleanup old generations: `cleanup` (alias for `sudo nix-collect-garbage -d`)

### Development

- Switch Java versions: `use-java [8|11|17|21]`
- Create and enter directory: `mkcd directory-name`

### Modern CLI Tools

The configuration includes modern replacements for common Unix tools:
- `ls` → `eza`
- `cat` → `bat`
- `find` → `fd`
- Plus `fzf` for fuzzy finding

## Customization

- Desktop Environment: Edit `desktopEnvironment` in `modules/core/desktop.nix`
- Packages: Modify `modules/home/packages.nix`
- Git configuration: Update `modules/home/git.nix`
- Fish shell: Customize `modules/home/fish.nix`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
