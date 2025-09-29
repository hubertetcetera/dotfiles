# Ghostty Setup

1. **Install Ghostty**
   Follow the official installation instructions: [https://ghostty.org](https://ghostty.org)

2. **Deploy via Stow**
   This repo uses `.stowrc` with `--target=~/.config`. Run:

```bash
cd dotfiles
stow ghostty
```

This creates:

```bash
~/.config/ghostty/config -> dotfiles/ghostty/config
~/.config/ghostty/themes -> dotfiles/ghostty/themes
```

3. **macOS users**
   Ghostty does not use `~/.config` by default on macOS. You’ll need a one-time bridge linking
   `~/Library/Application\ Support/com.mitchellh.ghostty/{config,themes}` to `~/.config/ghostty/...`.

See the [README](../README) for details.

3. **Fonts**

For best results, install a Nerd Font such as [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases).
This ensures proper rendering of icons and glyphs.

4. **Themes**

This setup uses the [Catppuccin](https://catppuccin.com/) Mocha theme.
You can switch themes in the config file or add more under the `themes/` directory.
