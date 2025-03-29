# 🚀 NixOS Config

My minimal NixOS setup with Flakes and Home Manager for efficient development and everyday use.

## ⚙️ Core Features

### 🖥️ System

- **Desktop Environment**: Choice between GNOME or KDE Plasma 6
- **Hardware Support**: Optimized for AMD CPU/GPU
- **Audio**: PipeWire audio system
- **Fonts**: Cascadia Code as default font family

### 🛠️ Development Environment

- **IDEs & Editors**:
  - Zed Editor
  - Godot 4.4
  - Blender
  - Android Studio
- **Languages & Runtimes**:
  - Java (8, 11, 17, 21) with version switcher
  - Rust toolchain with cargo
  - Bun JavaScript runtime
- **Build Tools**: CMake, GCC, Make, pkg-config
- **Version Control**: Git with LazyGit

### 📱 Applications

- **Browsers**: Zen Browser
- **Communication**:
  - Discord (with OpenASAR/Vencord)
  - Telegram Desktop
- **Media**:
  - EasyEffects
  - MPV Player
  - OBS Studio
  - Spotify
  - yt-dlp
- **Office**: LibreOffice Qt6
- **Gaming**:
  - Steam
  - Proton Compatibility Layer
  - Protontricks
  - Wine Staging

### 🐟 Shell Environment

- **Fish Shell**:
  - Modern prompt with git integration
  - Smart aliases
  - Java version management
  - Path management for Rust/Cargo/Bun
- **Modern CLI Tools**:
  - eza (modern ls)
  - bat (modern cat)
  - fd (modern find)
  - fzf (fuzzy finder)

## 🚀 Installation

1. Clone the repository:

```bash
git clone --depth=1 https://github.com/v1mkss/NixDots.git && cd NixDots
```

2. Run the installation script:

```bash
sh ./install.sh
```

## 📁 Project Structure

```
.
├── flake.nix               # Main configuration entry point
├── hosts/
│   └── v1mkss/             # Host-specific configurations
│       ├── configuration.nix # System configuration for the host
│       └── home.nix        # Home Manager entry point for the host
├── modules/
│   ├── core/               # System-level configurations (NixOS modules)
│   │   ├── desktop.nix     # Desktop Environment (GNOME/KDE)
│   │   ├── hardware.nix    # Hardware settings (CPU, GPU, drivers)
│   │   ├── network.nix     # Network configuration (hostname, NetworkManager)
│   │   ├── packages.nix    # Base system packages
│   │   ├── users.nix       # User account definitions
│   │   ├── sysctl.nix      # Kernel parameter configuration loader
│   │   ├── sysctl.d/       # Kernel parameter files
│   │   ├── modprobe.d/     # Kernel module option files
│   │   └── ...             # Other core modules (audio, boot, fonts, etc.)
│   └── home/               # User-level configurations (Home Manager modules)
│       ├── development.nix # Development tools and environment setup
│       ├── fish.nix        # Fish shell configuration, aliases, functions
│       ├── git.nix         # Git configuration
│       ├── packages.nix    # User-specific application packages
│       ├── steam.nix       # Steam and gaming related settings
│       └── ...             # Other user modules
├── install.sh              # Installation script
```

## ⚡ Customization Guide

### System Configuration

- Desktop Environment: Edit `modules/core/desktop.nix`
- Hardware Settings: Modify `modules/core/hardware.nix` and `modules/core/modprobe.d/`
- Kernel Parameters: Modify files in `modules/core/sysctl.d/`
- User Settings: Update `modules/core/users.nix`

### User Configuration

- Development Tools: Edit `modules/home/development.nix`
- Shell Settings: Modify `modules/home/fish.nix`
- Additional Packages: Update `modules/home/packages.nix`
- Git Settings: Edit `modules/home/git.nix`

## 🔧 Useful Commands

### System Management

```bash
cleanup                 # Clean old system generations
optimize                # Optimize Nix store (may take time)
```

### Development

```bash
use-java [8|11|17|21]  # Switch Java versions
mkcd <directory>       # Create and enter directory
```

### Enhanced CLI Commands

```bash
ls, l, la            # Enhanced file listing (eza)
cat <file>           # Enhanced file viewer (bat)
tree                 # Directory tree view (eza)
```

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
