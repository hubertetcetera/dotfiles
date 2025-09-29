# Ghostty Setup

1. **Install Ghostty**
   Follow the official installation instructions: [https://ghostty.org](https://ghostty.org)

2. **Clone this repo**

```bash
git clone https://github.com/hubertetcetera/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

3. **Install GNU Stow**

```bash
# macOS
brew install stow

# Debian/Ubuntu
sudo apt install stow

# Arch
sudo pacman -S stow
```

4. **Deploy Ghostty config**

```bash
stow ghostty
```

This will create symlinks into Ghostty’s default config directory:

- macOS → `~/Library/Application\ Support/com.mitchellh.ghostty/`
- Linux → `~/.config/ghostty/`
- Windows (experimental) → `%APPDATA%\ghostty\`

5. **Fonts**

For best results, install a Nerd Font such as [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases).
This ensures proper rendering of icons and glyphs.

6. **Themes**

This setup uses the [Catppuccin](https://catppuccin.com/) Mocha theme.
You can switch themes in the config file or add more under the `themes/` directory.
