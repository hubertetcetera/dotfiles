PS1="%1~ → "

if command -v brew >/dev/null; then
  BREW_PREFIX=$(brew --prefix)
  [ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

bindkey jj vi-cmd-mode    
 
# Created by `pipx` on 2024-08-02 12:36:27
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export LIBCLANG_PATH="$(brew --prefix llvm)/lib"
export PATH="$(brew --prefix llvm)/bin:$PATH"
export SDKROOT="$(xcrun --show-sdk-path)"
export BINDGEN_EXTRA_CLANG_ARGS="--sysroot=$(xcrun --show-sdk-path)"
export RUSTC_WRAPPER=sccache

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide
if command -v zoxide >/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi
