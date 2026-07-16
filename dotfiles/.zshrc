export ZSH="${HOME}/.oh-my-zsh"
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

if [[ -s "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
fi

[[ -f "${HOME}/.exports" ]] && source "${HOME}/.exports"
[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"
[[ -f "${HOME}/.functions" ]] && source "${HOME}/.functions"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

export NVM_DIR="${HOME}/.nvm"
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
elif [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
  source "/usr/local/opt/nvm/nvm.sh"
fi

