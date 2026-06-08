# Common aliases
alias cls='clear'
alias ls='eza --icons'
alias python='python3'
alias pip='python3 -m pip'
alias secman='~/.bin/secman/build/secman'
alias wormhole='wormhole-rs'
alias uni='cd ~/Desktop/DVergaraM/Universidad/2026_1'
alias java='"/c/Program Files/Java/jdk-21/bin/java"'
alias personal='cd ~/Desktop/DVergaraM/Personal/'
alias cwd='pwd'
alias obsidian='cd ~/Desktop/DVergaraM/Apps/Main/'
alias lg='lazygit'
alias mingw32-ext='wt.exe -p "MinGW-32"'
alias htop='neohtop'
alias java='~/scoop/apps/openjdk25/current/bin/java.exe'
alias javac='~/scoop/apps/openjdk25/current/bin/javac.exe'
alias javaws='~/scoop/apps/openjdk25/current/bin/javaw.exe'


# Aliases with functions and without admin permissions
alias fg='function _fg() {
  if [[ -d .git ]]; then
    for arg in "$@"; do
      case "$arg" in
        f) git fetch --all && git pull ;;
        p) git push ;;

        *) echo "Usage: fg [f|p]" ;;
      esac
    done
    [[ $# -eq 0 ]] && echo "Usage: fg [f|p]"
  else
    echo "Not a git repository.";
    return 1;
  fi;
};
_fg'

alias dns='function _dns() {
    doggo --json "$1" | jq ".responses[0].answers[0]";
    return 0;
};
_dns'
alias dev='function _dev() {
    for arg in "$@"; do
        case "$arg" in
            local) 
              if [[ -d ~/Desktop/DVergaraM/Dev/ ]]; then
                cd ~/Desktop/DVergaraM/Dev/;
              else
                echo "Directory ~/Desktop/DVergaraM/Dev does not exist. Please check the path and try again.";
                return 1;
              fi
              ;;
            disco) 
              if [[ -d /f/Dev/ ]]; then
                cd /f/Dev;
              else
                echo "Directory /f/Dev does not exist. Please check the path and try again.";
                return 1;
              fi
              ;;
            *) echo "Usage: dev [local|disco]" ;;
        esac
    done
    [[ $# -eq 0 ]] && echo "Usage: dev [local|disco]"
};
_dev'

alias mkcd='function _mkcd() {
    mkdir "$1" && cd "$1";
    return 0;
};
_mkcd'
alias pdf='function _pdf() {
    sumatrapdf "$1";
    return 0;
};
_pdf'
alias readme='function _readme(){
    if [[ -f "$1" ]]; then
        glow "$1";
    else
        echo "Error: File '$1' not found.";
        return 1;
    fi;
};
_readme'
alias back='function _back() {
    if [[ -f ~/.cwd ]]; then
        TARGET_DIR=$(cat ~/.cwd | tr -d '"'"'[:space:]'"'"');
        if [[ -n "$TARGET_DIR" ]] && [[ -d "$TARGET_DIR" ]]; then
            cd "$TARGET_DIR";
        else
            echo "Error: ~/.cwd file is empty or directory does not exist.";
            return 1;
        fi;
    else
        echo "Error: ~/.cwd file not found. Use '"'"'cd'"'"' first to create it.";
        return 1;
    fi;
};
_back'
alias img='function _img() {
    if [[ -f "$1" ]]; then
        chafa "$1";
    else
        echo "Error: File '$1' not found.";
        return 1;
    fi;
};
_img'
alias loadnvm='function _loadnvm(){
    source ~/.nvm/nvm.sh;
    source ~/.nvm/bash_completion;
};
_loadnvm'
alias rpcc='function _rpcc(){
    ~/.oh-my-zsh/custom/plugins/discord-rpc/discord_rpc_control.sh "$@";
};
_rpcc'
alias rpcm='function _rpcm(){
    ~/.oh-my-zsh/custom/plugins/discord-rpc/discord_rpc_monitor.sh "$@";
};
_rpcm'
alias vn='function _vn() {
    if [[ -d .venv ]]; then
        source .venv/Scripts/activate;
    else
        echo "No .venv directory found in the current directory.";
    fi;
};
_vn'


# Aliases with functions that require admin permissions


alias update='function _update() {
    if fltmc.exe >/dev/null 2>&1; then
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
    else
        echo "ERROR: Must run this command as an administrator to perform updates." >&2;
    fi
}; _update'
alias enable-proxy='function _enable_proxy() {
    if fltmc.exe >/dev/null 2>&1; then
        netsh winhttp set proxy proxy-server="http=discproxy.virtual.uniandes.edu.co:443;https=discproxy.virtual.uniandes.edu.co:443" bypass-list="localhost";
    else
        echo "ERROR: Must run this command as an administrator to enable the proxy." >&2;
    fi
};
_enable_proxy'
alias disable-proxy='function _disable_proxy() {
    if fltmc.exe >/dev/null 2>&1; then
        netsh winhttp reset proxy
    else
        echo "ERROR: Must run this command as an administrator to disable the proxy." >&2;
    fi
};
_disable_proxy'
alias clear-cache='function _clear_cache() {
    if fltmc.exe >/dev/null 2>&1; then
        for arg in "$@"; do
            scoop cache rm "$arg" 2>/dev/null || echo "No cache found for $arg" >&2;
            scoop cleanup -k "$arg" 2>/dev/null || echo "No cleanup needed for $arg" >&2;
        done
        [[ $# -eq 0 ]] && echo "Usage: clear-cache [package1 package2 ...]"
    else
        echo "ERROR: Must run this command as an administrator to clear the cache." >&2;
    fi
};_clear_cache'
