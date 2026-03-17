alias cls='clear'
alias ls='eza --icons'
alias python='python3'
alias pip='python3 -m pip'
alias secman='~/.bin/secman/build/secman'
alias wormhole='wormhole-rs'
alias mkcd='function _mkcd() { mkdir "$1" && cd "$1"; };_mkcd'
alias uni='cd ~/Desktop/DVergaraM/Universidad/2026_1'
alias java='"/c/Program Files/Java/jdk-21/bin/java"'
alias dev='cd ~/Desktop/DVergaraM/Dev/'
alias personal='cd ~/Desktop/DVergaraM/Personal/'
alias pdf='function _pdf(){ sumatrapdf "$1"; };_pdf'
alias readme='function _readme(){ glow "$1"; };_readme'
alias cwd='pwd'
alias back='function _back() { if [[ -f ~/.cwd ]]; then TARGET_DIR=$(cat ~/.cwd | tr -d '"'"'[:space:]'"'"'); if [[ -n "$TARGET_DIR" ]]; then cd "$TARGET_DIR"; else echo "Error: ~/.cwd file is empty."; return 1; fi; else echo "Error: ~/.cwd file not found. Use '"'"'cd'"'"' first to create it."; return 1; fi; }; _back'
alias img='function _img() { chafa "$@"; };_img'
alias loadnvm='function _loadnvm(){ source ~/.nvm/nvm.sh; source ~/.nvm/bash_completion; };_loadnvm'
alias rpcc='function _rpcc(){ ~/.oh-my-zsh/custom/plugins/discord-rpc/discord_rpc_control.sh "$@"; };_rpcc'
alias rpcm='function _rpcm(){ ~/.oh-my-zsh/custom/plugins/discord-rpc/discord_rpc_monitor.sh "$@"; };_rpcm'
alias vn='function _vn() { if [[ -d .venv ]]; then source .venv/Scripts/activate; else echo "No .venv directory found in the current directory."; fi; }; _vn'
alias obsidian='cd ~/Desktop/DVergaraM/Apps/Main/'
alias dns='function _dns() { doggo --json "$1" | jq ".responses[0].answers[0]"; };_dns'
alias lg='lazygit'
alias update='function _update() { 
  for arg in "$@"; do
    case "$arg" in
      scoop) scoop update && scoop update --all ;;
      node) nvm install --lts --reinstall-packages-from=node && nvm install-latest-npm ;;
      pip) pip install --upgrade pip && pip list --outdated | tail -n +3 | cut -d " " -f 1 | xargs -n1 pip install -U ;;
      all) _update scoop node pip ;;
      *) echo "Usage: update [scoop|node|pip|all]" ;;
    esac
  done
  [[ $# -eq 0 ]] && echo "Usage: update [scoop|node|pip|all]"
}; _update'
alias mingw32-ext='wt.exe -p "MinGW-32"'
##alias uv='uvicorn'
alias enable-proxy='netsh winhttp set proxy proxy-server="http=discproxy.virtual.uniandes.edu.co:443;https=discproxy.virtual.uniandes.edu.co:443"'
alias disable-proxy='netsh winhttp reset proxy'
alias htop='neohtop'
