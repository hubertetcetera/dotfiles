# nix-darwin Setup

This repository assumes your flake.nix is in a subdirectory (e.g., `./nix/`).

## 1. Prerequisites (macOS)

1. **Install Homebrew:** (Used for initial package/cask setup)

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Nix with multi-user support:**

   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

3. **Configure Flake:** Replace `username = "etcetera";` with your actual macOS username.

   ```bash
   sed -i '' "s@etcetera@$(whoami)@g" flake.nix
   ```

## 2. Initial Configuration and Subsequent Updates

Run the system activation script. Since this involves system-level changes (like installing packages and setting up services), it **MUST** be run with `sudo`.

Navigate to the directory containing your `flake.nix` (e.g., `cd nix`).

```bash
sudo nix run --experimental-features "nix-command flakes" nix-darwin -- switch --flake .#meow
```

Make sure to restart your terminal or source your shell configuration file to apply the changes before running the next command.

```bash
sudo darwin-rebuild switch --flake .#meow
```
