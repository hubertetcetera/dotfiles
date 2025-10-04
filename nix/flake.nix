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

    username = builtins.getEnv "USER";
    homeDirectory = "/Users/${username}";
    mkHomeConfig = pkgs: {
      # Declaratively manage dotfiles (replaces stow)
      home.file = {
        # ".zshrc".source = ./zshrc;
        # ".config/nvim".source = ./nvim;
        # ".config/tmux/tmux.conf".source = ./tmux/tmux.conf;
        # ".config/tmux/tmux.reset.conf".source = ./tmux/tmux.reset.conf;
        # ".config/ghostty/config".source = ./ghostty/config;
        # ".config/ghostty/themes".source = ./ghostty/themes;
        # ".config/aerospace/aerospace.toml".source = ./aerospace/aerospace.toml;
        # ".hammerspoon".source = ./hammerspoon;
        # ".config/sketchybar".source = ./sketchybar;
      };

      # Programs managed by Home Manager
      programs.zsh.enable = true;
      programs.tmux.enable = true;

      # User-level packages
      home.packages = with pkgs; [
        neovim
        tmux
        zoxide
        stow
        nodejs
        nerd-fonts.jetbrains-mono
      ];

      home.username = username;
      home.homeDirectory = homeDirectory;
      home.stateVersion = "25.05";
    };

    homeConfigurations = {
      "${username}@meow" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ (mkHomeConfig nixpkgs.legacyPackages.aarch64-darwin) ];
      };
      
      "${username}@linux-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ (mkHomeConfig nixpkgs.legacyPackages.x86_64-linux) ];
      };
    };
  in {
    darwinConfigurations."meow" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {
            imports = [
              self.homeConfigurations."${username}@meow".options.home.activation.setupUser
            ];
          };
        }
        {
          nixpkgs.hostPlatform = "aarch64-darwin";

          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          environment.systemPackages = with nixpkgs.legacyPackages.aarch64-darwin; [
            docker
            rustup
            # Add any other core system-level tools here
          ];

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

          system.primaryUser = username;
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
        }
      ];
    };

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
          nerd-fonts.jetbrains-mono
        ] ++ (if pkgs.stdenv.isLinux then [
          ghostty
        ] else []);

        shellHook = ''
          echo "🐧 Cross-platform shell ready on ${system}"
        '';
      };
    });
  };
}
