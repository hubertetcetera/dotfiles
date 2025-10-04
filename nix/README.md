# nix

Install homebrew on macOS:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install Nix with multi-user support:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Then replace `etcetera` with your username in `flake.nix` using the command below, and run the following commands to set up `nix-darwin`:

```bash
sed -i '' "s@etcetera@$(whoami)@g" flake.nix
sudo nix run --experimental-features "nix-command flakes" nix-darwin -- switch --flake .#meow
```

Make sure to restart your terminal or source your shell configuration file to apply the changes before running the next command.

Finally, apply the configuration with:

```
sudo darwin-rebuild switch --flake .#meow
```
