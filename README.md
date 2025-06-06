# 🚀 NixOS Config

My optimized, minimal NixOS setup featuring Flakes and Home Manager for streamlined development and daily usage.

## ⚙️ Core Features

### 🖥️ System

- **Desktop Environment**: KDE Plasma 6 Wayland(Only)
- **Hardware Support**: Optimized for AMD CPU/IGPU/GPU
- **Audio**: PipeWire audio system
- **Fonts**: Cascadia Code as default font family

### 🛠️ Development Environment

- **IDEs & Editors**:
  - Zed Editor
- **Languages & Runtimes**: Direnv
- **Version Control**: Git with LazyGit

### 📱 Applications

- **Browsers**: Zen Browser
- **Communication**:
  - Discord (with OpenASAR/Vencord)
  - Telegram Desktop
- **Media**:
  - Audacious
  - EasyEffects
  - MPV Player
  - YouTube Music
  - yt-dlp
- **Office**: LibreOffice Qt6
- **Gaming**:
  - Steam
  - Lutris
  - ProtonPlus/Proton/etc
  - Wine

### 🐟 Shell Environment

- **Fish Shell**:
  - Modern prompt with git integration
  - Smart aliases
- **Modern CLI Tools**:
  - eza (modern ls)
  - bat (modern cat)
  - fd (modern find)
  - fzf (fuzzy finder)

## 🚀 Installation

1.  Clone the repository:

```bash
git clone --depth=1 https://github.com/v1mkss/NixDots.git && cd NixDots
```

2.  Run the installation script:

```bash
sh ./install.sh
```

## 🔧 Useful Commands

### System Management

```bash
cleanup                 # Clean old system generations
optimize                # Optimize Nix store (may take time)
```

### Enhanced CLI Commands

```bash
ls, l, la            # Enhanced file listing
cat <file>           # Enhanced file viewer
tree                 # Directory tree view
mkcd <directory>      # Create and enter directory
```

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
