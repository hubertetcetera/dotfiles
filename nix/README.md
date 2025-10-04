# nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Then replace `etcetera` with your username in `flake.nix` using the command below, and run the following commands to set up `nix-darwin`:

```bash
sed -i '' "s@etcetera@$(whoami)@g" flake.nix
sudo nix run --experimental-features "nix-command flakes" nix-darwin -- switch --flake .#meow
sudo darwin-rebuild switch --flake .#meow
```
