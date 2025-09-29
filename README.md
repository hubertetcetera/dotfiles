# dotfiles

A portable collection of my configs to bootstrap new machines.
Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## 🚀 Quick Setup

1. **Clone the repo**

```bash
git clone https://github.com/hubertetcetera/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. **Install GNU Stow**

```bash
# macOS
brew install stow
# Debian/Ubuntu
sudo apt install stow
# Arch
sudo pacman -S stow
```

3. **Deploy configs**

```bash
stow .
```

This will symlink everything in the repo into the correct locations.

See the README inside each directory for specifics:

- [tmux](tmux/README.md)
- [ghostty](ghostty/README.md)
