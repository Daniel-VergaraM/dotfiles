export NVM_DIR="$HOME/.nvm"
if [ -t 1 ]; then
  exec zsh
fi

# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# if command -v zoxide > /dev/null; then
#  eval "$(zoxide init bash)"
# fi
