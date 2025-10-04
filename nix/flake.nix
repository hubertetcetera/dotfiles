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

    lib = nixpkgs.lib;
    username = let
      su = builtins.getEnv "SUDO_USER";
      u  = builtins.getEnv "USER";
    in if su != null && su != "" then su
       else if u  != null && u  != "" then u
       else "etcetera";

    mkHomeConfig = pkgs: {
      home.username = lib.mkForce username;
      home.homeDirectory = lib.mkForce (
        if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}"
      );
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

      home.stateVersion = "25.05";
    };
  in {

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
    darwinConfigurations."meow" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = mkHomeConfig nixpkgs.legacyPackages.aarch64-darwin;
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
            taps = [ "nikitabobko/tap" ];
            casks = [
              "ghostty"
              "aerospace"
              "sf-symbols"
              "raycast"
              "arc"
            ];
            # ensure casks land in /Applications (not ~/Applications or “Nix Apps”)
            caskArgs.appdir = "/Applications";
            onActivation = {
              autoUpdate = true;
              cleanup = "zap";
            };
            brews = [ "dockutil" ];
          };
          system.activationScripts.setDock.text = ''
          # remove all app tiles (keeps “Downloads” etc. untouched)
          /opt/homebrew/bin/dockutil --remove all --no-restart || true

          # add apps in order (only if they actually exist)
          add_if() {
            [ -e "$1" ] && /opt/homebrew/bin/dockutil --add "$1" --no-restart
          }

          add_if "/System/Applications/Launchpad.app"
          add_if "/Applications/Arc.app"
          add_if "/System/Applications/System Settings.app"
          add_if "/Applications/Ghostty.app"

          # restart Dock to apply
          killall Dock || true
        '';
          system.primaryUser = username;
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
        }
        {
          system.defaults.dock = {
            autohide = true;
            "show-recents" = false;
            tilesize = 64;
          };
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
