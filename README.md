# 🚀 Linux Config

My optimized, minimal Linux setup featuring Home Manager for streamlined development and daily usage.

## ⚙️ Core Features

### 🐟 Shell Environment (Fish)

- Modern prompt with git integration
- Smart aliases and functions
- Command-not-found handler
- Custom color scheme
- Directory navigation shortcuts
- Modern CLI Tools:
  - eza (modern ls)
  - bat (modern cat)
  - fd (modern find)
  - fzf (fuzzy finder)

### 💻 Terminal (Alacritty)

- Custom Catppuccin Mocha theme
- Cascadia Code font configuration
- Window opacity and blur effects
- Optimized scrolling
- Smart window padding

### 🏃 System Info (Fastfetch)

- Fedora-styled logo
- Customized system information display
- Shows OS, kernel, host, packages, uptime, and RAM
- Minimalist color scheme
- Clean layout with custom separators

### 🌿 Git Configuration

- Smart default branch settings
- Custom color scheme for UI elements
- Global gitignore settings
- Automatic remote setup
- GPG signing support

## 🚀 Installation

1. Clone the repository:

```bash
git clone --depth=1 https://github.com/v1mkss/NixDots.git && cd NixDots
```

2. Install Home Manager:

Follow the [Home Manager installation guide](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone).

3.  Apply the configuration:

```bash
./install.sh
```

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
