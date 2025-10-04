# nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Set your username as an environment variable

```bash
export USER=$(whoami)
nix run nix-darwin -- switch --flake .#meow
sudo darwin-rebuild switch --flake .#meow
```
