# Prompt
PS1="%1~ → "

# Detect platform
IS_MACOS=$(uname | grep -qi 'darwin' && echo true || echo false)
IS_LINUX=$(uname | grep -qi 'linux' && echo true || echo false)

# macOS‑only: brew + xcrun
if [[ "$IS_MACOS" == "true" ]]; then
  # Make brew always available
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
  if command -v brew >/dev/null; then
    BREW_PREFIX=$(brew --prefix)
    [ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
      source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
      source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi

  # MongoDB path (mac only)
  export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"

  # LLVM / SDKROOT (mac only)
  if command -v brew >/dev/null; then
    export LIBCLANG_PATH="$(brew --prefix llvm)/lib"
    export PATH="$(brew --prefix llvm)/bin:$PATH"
  fi
  if command -v xcrun >/dev/null; then
    export SDKROOT="$(xcrun --show-sdk-path)"
    export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$(xcrun --show-sdk-path)"
  fi
fi

# Linux‑only: add local bin, etc.
if [[ "$IS_LINUX" == "true" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
  # optional: source autosuggestions if installed via nix
  [ -f "/etc/zsh/zsh-autosuggestions.zsh" ] && source "/etc/zsh/zsh-autosuggestions.zsh"
  [ -f "/etc/zsh/zsh-syntax-highlighting.zsh" ] && source "/etc/zsh/zsh-syntax-highlighting.zsh"
fi

# Shared keybindings (only if bindkey exists)
if command -v bindkey >/dev/null; then
  bindkey '^w' autosuggest-execute
  bindkey '^e' autosuggest-accept
  bindkey '^u' autosuggest-toggle
  bindkey '^L' vi-forward-word
  bindkey '^k' up-line-or-search
  bindkey '^j' down-line-or-search
  bindkey jj vi-cmd-mode
fi

# pnpm (shared)
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Rust caching
export RUSTC_WRAPPER=sccache
# Cargo env (if exists)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide
if command -v zoxide >/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi
