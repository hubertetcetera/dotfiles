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

4. **Deploy tmux config**

```bash
stow tmux
```

This will create a symlink from `~/.config/tmux/tmux.conf` to `~/dotfiles/tmux/tmux.conf`.

```bash
~/.config/tmux/tmux.conf -> ~/dotfiles/tmux/tmux.conf
```

5. **Install TPM (Tmux Plugin Manager)**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

6. **Start tmux and install plugins**
   Inside tmux, press:

```bash
prefix + I
```

(Default prefix is Ctrl+a in this config.)

7. **Reload config**

```bash
tmux source-file ~/.config/tmux/tmux.conf
```
