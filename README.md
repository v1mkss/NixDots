# 🚀 NixOS Config

My minimal NixOS setup with Flakes and Home Manager for efficient development.

## ⚙️ Core Features

### 🖥️ System
- GNOME/KDE desktop environments
- AMD GPU optimization
- PipeWire audio
- Cascadia Code fonts

### 🛠️ Development
- JetBrains Suite (IDEA, WebStorm, Rust-Rover)
- Zed Editor
- Java (8,11,17,21)
- Rust toolchain
- Bun runtime
- Build tools (CMake, GCC, etc)

### 📱 Apps
- Floorp browser
- Discord (OpenASAR/Vencord)
- Telegram
- OBS Studio
- MPV
- Spotify
- LibreOffice
- And many more applications and tools available in the Nix ecosystem!

### 🐟 Shell
- Fish with modern prompt
- Git integration
- Productivity aliases
- Modern CLI tools

## 🏃 Quick Start

```bash
git clone https://github.com/v1mkss/nixos-config
cd nixos-config
sh ./install.sh
```

## 📁 Structure

```
.
├── flake.nix          # Main config
├── hosts/v1mkss/      # Host config
├── modules/           # Core modules
└── install.sh         # Setup script
```

## ⚡ Customization

Key files:
- System: `modules/core/desktop.nix`
- User: `modules/home/development.nix`
- Shell: `modules/home/fish.nix`

## 🔧 Commands

System:
- `cleanup` - Clear old generations

Dev:
- `use-java [8|11|17|21]` - Switch Java versions
- `mkcd <dir>` - Create and enter directory

CLI:
- `ls/l/la` - Enhanced listing (eza)
- `cat` - Enhanced viewer (bat)
- `fd/fzf` - Smart find

## 📄 License
This configuration and all related code is provided under the [MIT License](./LICENSE), granting you full permission to use, modify, and share this work freely.
