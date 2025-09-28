# 🛠️ Tmux Setup

1. **Install tmux**

```bash
# macOS
brew install tmux

# Debian/Ubuntu
sudo apt install tmux

# Arch
sudo pacman -S tmux
```

2. **Download and apply config**

```bash
mkdir -p ~/.config/tmux
curl -fsSL https://raw.githubusercontent.com/hubertetcetera/dotfiles/refs/heads/main/tmux/tmux.conf -o ~/.config/tmux/tmux.conf
```

_(If you prefer the classic location, symlink it to ~/.tmux.conf)_

```bash
ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
```

3. **Install TPM (Tmux Plugin Manager)**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

4. **Start tmux and install plugins**

```bash
prefix + I
```

(default prefix is `Ctrl+b` but it is mapped to `Ctrl+A` for this config, unless you changed it).
This will clone and install all plugins listed in the config.

5. **Reload config**
   Either restart tmux or run inside tmux:

```bash
tmux source-file ~/.config/tmux/tmux.conf
```
