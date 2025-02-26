# 🚀 NixOS Config

My minimal NixOS setup with Flakes and Home Manager for efficient development.

## ⚙️ Core Features

### 🖥️ System
- **Desktop Environment**: Choice between GNOME or KDE Plasma 6
- **Hardware Support**: Optimized for AMD GPU with ROCm support
- **Audio**: PipeWire audio system
- **Fonts**: Cascadia Code as default font family

### 🛠️ Development Environment
- **IDEs & Editors**:
  - JetBrains Suite (IDEA Ultimate, WebStorm, Rust-Rover)
  - VSCodium
  - Godot 4
- **Languages & Runtimes**:
  - Java (8, 11, 17, 21) with version switcher
  - Rust toolchain with cargo
  - Bun JavaScript runtime
- **Build Tools**: CMake, GCC, Make, pkg-config
- **Version Control**: Git with LazyGit

### 📱 Applications
- **Browsers**: Brave
- **Communication**:
  - Discord (with OpenASAR/Vencord)
  - Telegram Desktop
- **Media**:
  - OBS Studio
  - MPV Player
  - Spotube
- **Office**: LibreOffice Qt6

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
git clone https://github.com/v1mkss/nixos-config
```

2. Navigate to the directory:
```bash
cd nixos-config
```

3. Run the installation script:
```bash
sh ./install.sh
```

## 📁 Project Structure

```
.
├── flake.nix                # Main configuration entry point
├── hosts/
│   └── v1mkss/             # Host-specific configurations
│       ├── configuration.nix
│       └── home.nix
├── modules/
│   ├── core/               # System-level configurations
│   │   ├── desktop.nix     # DE configuration
│   │   ├── hardware.nix    # Hardware settings
│   │   ├── network.nix     # Network configuration
│   │   └── ...
│   └── home/               # User-level configurations
│       ├── development.nix # Development tools
│       ├── fish.nix       # Shell configuration
│       └── packages.nix    # User packages
└── install.sh              # Installation script
```

## ⚡ Customization Guide

### System Configuration
- Desktop Environment: Edit `modules/core/desktop.nix`
- Hardware Settings: Modify `modules/core/hardware.nix`
- User Settings: Update `modules/core/users.nix`

### User Configuration
- Development Tools: Edit `modules/home/development.nix`
- Shell Settings: Modify `modules/home/fish.nix`
- Additional Packages: Update `modules/home/packages.nix`

## 🔧 Useful Commands

### System Management
```bash
cleanup                 # Clean old system generations
sudo nixos-rebuild switch --flake .#  # Rebuild system
```

### Development
```bash
use-java [8|11|17|21]  # Switch Java versions
mkcd <directory>       # Create and enter directory
```

### Enhanced CLI Commands
```bash
ls, l, la             # Enhanced file listing (eza)
cat <file>           # Enhanced file viewer (bat)
tree                 # Directory tree view
```

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
