# 🚀 NixOS Config

My optimized, minimal NixOS setup featuring Flakes and Home Manager for streamlined development and daily usage.

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
  - DaVinci Resolve (To install, uncomment `davinci-resolve.nix` in [profiles/desktop/home/packages.nix](https://github.com/v1mkss/NixDots/blob/update/profiles/desktop/home/pkgs/default.nix)
  - EasyEffects
  - MPV Player
  - YouTube Music
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
