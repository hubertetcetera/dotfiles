{
  description = "Meow cross-platform flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }: let
    supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in {
    darwinConfigurations."meow" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        {
          nixpkgs.hostPlatform = "aarch64-darwin";

          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          environment.systemPackages = with nixpkgs.legacyPackages.aarch64-darwin; [
            neovim
            tmux
            rustup
            docker
            stow
            zoxide
            nodejs
            pkgs.nerd-fonts.jetbrains-mono
            # ghostty is NOT available via nixpkgs on macOS
          ];

          programs.zsh.enable = true;

          # Homebrew casks for mac-only tools
          homebrew = {
            enable = true;
            casks = [
              "ghostty"
              "aerospace"
              "sf-symbols"
              "raycast"
              "arc"
            ];
          };

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
        }
      ];
    };

    # Optional: future homeManager configurations can go here
    # homeConfigurations.username = home-manager.lib.homeManagerConfiguration { ... };

    # Shared devShell for both macOS and Linux
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          neovim
          tmux
          rustup
          docker
          stow
          zoxide
          nodejs
          pnpm
          pkgs.nerd-fonts.jetbrains-mono
        ] ++ (if pkgs.stdenv.isLinux then [
          ghostty
          i3
          polybar
        ] else []);

        shellHook = ''
          echo "🐧 Cross-platform shell ready on ${system}"
        '';
      };
    });
  };
}
