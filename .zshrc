# ============================================================
# 1. INSTANT PROMPT - Powerlevel10k
# Mantener arriba para evitar parpadeos
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ============================================================
# 2. VARIABLES DE ENTORNO Y PATHS
# ============================================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="/home/dvergaram/.opencode/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export TERM="xterm-256color"

# Fix para kitty keyboard protocol en Ghostty/winghostty
# Evita que teclas como ~ se conviertan en secuencias ;Xu
printf '\033[<u'

export DISCORD_CLIENT_ID="1413033469017067672"
export RPC_LOCK="$HOME/.discord-rpc-monitor.lock"

export STARSHIP_LOG="error"


# ============================================================
# 3. ZINIT - Plugin Manager
# ============================================================
export ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}Installing Zinit...%f"
  command mkdir -p "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"


# ============================================================
# 4. OPCIONES DE ZSH
# ============================================================
setopt autocd
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Glob y match case-insensitive
unsetopt CASE_GLOB
unsetopt CASE_MATCH


# ============================================================
# 5. HISTORIAL
# ============================================================
HISTSIZE=2000
SAVEHIST=2000


# ============================================================
# 6. COMPLETIONS
# ============================================================
autoload -Uz compinit
compinit -C

# Completion case-insensitive
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'


# ============================================================
# 7. AUTOCOMPLETE CASE-INSENSITIVE
# ============================================================
zstyle ':autocomplete:*' verbose no
zstyle ':autocomplete:*' matcher 'm:{a-zA-Z}={A-Za-z}'
zstyle ':autocomplete:list-choices:*' matcher 'm:{a-zA-Z}={A-Za-z}'

autocd_case_insensitive() {
  if [[ -z "$BUFFER" ]]; then
    zle .accept-line
    return
  fi

  local cmd="$BUFFER"
  local found_dir

  found_dir=$(find . -maxdepth 1 -type d -iname "$cmd" 2>/dev/null | head -1)

  if [[ -n "$found_dir" && "$found_dir" != "." && "$found_dir" != "./" ]]; then
    local dir_name
    dir_name=$(basename "$found_dir")
    BUFFER="cd \"$dir_name\""
    zle accept-line
    return
  fi

  zle .accept-line
}

zle -N accept-line autocd_case_insensitive
bindkey '^M' accept-line


# ============================================================
# 8. PLUGINS
# ============================================================

# Debe cargar primero
zinit light marlonrichert/zsh-autocomplete

# Plugins async
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# Anexos de Zinit
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust


# ============================================================
# 9. PROMPT - Starship
# ============================================================
eval "$(starship init zsh)"


# ============================================================
# 10. LAZY NVM
# ============================================================
export NVM_DIR="$HOME/.nvm"

load-nvm() {
  unset -f node npm npx nvm

  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  else
    echo "Error: nvm.sh no encontrado en $NVM_DIR"
    return 1
  fi
}

for cmd in node npm npx nvm; do
  eval "$cmd() { load-nvm; command $cmd \"\$@\" }"
done


# ============================================================
# 11. PROXY UNIANDES
# ============================================================
export PROXY_HOST="discproxy.virtual.uniandes.edu.co"
export PROXY_PORT="443"
export PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"
alias pon='proxy_on'
alias poff='proxy_off'
alias pstate='env | grep -i proxy'


# ============================================================
# 12. FUNCIONES PERSONALIZADAS
# ============================================================

autoload -Uz add-zsh-hook


# ------------------------------------------------------------
# Guardar directorio actual
# ------------------------------------------------------------
store_cwd_on_cd() {
  if [[ "$OLDPWD" != "$PWD" ]]; then
    pwd -P >! ~/.cwd 2>/dev/null
  fi
}

chpwd_functions+=(store_cwd_on_cd)


# ------------------------------------------------------------
# back: volver al último directorio guardado
# ------------------------------------------------------------
back() {
  if [[ -f ~/.cwd ]]; then
    local TARGET_DIR
    TARGET_DIR=$(cat ~/.cwd | tr -d '[:space:]')

    if [[ -n "$TARGET_DIR" && -d "$TARGET_DIR" ]]; then
      cd "$TARGET_DIR" || return 1
    else
      echo "Error: ~/.cwd está vacío o el directorio no existe."
      return 1
    fi
  else
    echo "Error: ~/.cwd no existe. Usa cd primero para crearlo."
    return 1
  fi
}

_back_completion() {
  local -a dirs

  if [[ -f ~/.cwd ]]; then
    local saved_dir
    saved_dir=$(cat ~/.cwd | tr -d '[:space:]')

    if [[ -n "$saved_dir" ]]; then
      dirs=("$saved_dir")
    fi
  fi

  compadd -a dirs
}

compdef _back_completion back


# ------------------------------------------------------------
# mkcd: crear directorio y entrar
# ------------------------------------------------------------
mkcd() {
  if [[ -z "$1" ]]; then
    echo "Error: mkcd requiere un nombre de directorio"
    echo "Uso: mkcd <directorio>"
    return 1
  fi

  mkdir -p "$1" && cd "$1"
}

_mkcd_completion() {
  local -a dirs_to_complete
  local current_word="${words[-1]}"

  if [[ -z "$current_word" ]]; then
    dirs_to_complete=($(ls -d */ 2>/dev/null | sed 's/\/$//'))
    compadd -a dirs_to_complete
  else
    dirs_to_complete=($(ls -d */ 2>/dev/null | sed 's/\/$//' | grep -i "^${current_word}"))

    if [[ ${#dirs_to_complete[@]} -gt 0 ]]; then
      compadd -a dirs_to_complete
    else
      compadd "$current_word"
    fi
  fi
}

compdef _mkcd_completion mkcd


# ============================================================
# 13. POST-STARTUP
# ============================================================

__startup_done=false

post_startup() {
  if [[ "$__startup_done" == false ]]; then
    __startup_done=true

    sleep 0.5

    # Descomenta si quieres actualizar Scoop siempre al abrir terminal.
    # Ojo: puede hacer lenta la apertura.
    scoop update && scoop update --all && clear

    nvm use

    clear
    fastfetch
    echo "Bienvenido $(whoami)"
  fi
}

add-zsh-hook precmd post_startup


STATUS_LOG_FILE="$HOME/.cmd_errors.log"

log_and_reset_status() {
  # 1. Immediately capture the last command's exit code
  local last_status=$?

  # 2. Only log if the command actually failed (status is not 0)
  if [ $last_status -ne 0 ]; then
    # Get the last command from history
    local last_cmd=$(fc -ln -1) 
    
    # Log the timestamp, exit code, and command to the file
    echo "$(date '+%Y-%m-%d %H:%M:%S') [EXIT: $last_status] Cmd: $last_cmd" >> "$STATUS_LOG_FILE"
  fi

  # 3. Force the status back to 0 for the prompt
  true
}

add-zsh-hook precmd log_and_reset_status

kill_children_on_exit() {
  # 1. Kill all background jobs and child processes of this process group
  kill -TERM -- -$$ 2>/dev/null
  
  # 2. Give the processes a tiny moment to spin down gracefully
  sleep 0.1
  
  # 3. Force-kill any stubborn remaining direct child PIDs
  local children=$(pgrep -P $$)
  if [ -n "$children" ]; then
    kill -KILL $children 2>/dev/null
  fi
}

add-zsh-hook zshexit kill_children_on_exit

alias ff=fastfetch

# ============================================================
# 14. ALIASES EXTERNOS
# ============================================================
if [[ -f ~/.zsh_aliases ]]; then
  source ~/.zsh_aliases
fi

export EDITOR=vim

# 15. RClone 
# Sincronización asíncrona de Desktop a Google Drive
#if ! pgrep -f "rclone sync.*1CjiPOmftyqRf4P9ngl0nwAyrTP5H9Vd1" > /dev/null; then
    # Quitamos --progress y añadimos la redirección y &!
#    rclone sync ~/Desktop "gdrive:1CjiPOmftyqRf4P9ngl0nwAyrTP5H9Vd1" \
#        --exclude-from ~/AppData/Roaming/driveignore/.global_driveignore \
#        > /tmp/rclone_desktop_sync.log 2>&1 &!
#fi
export PATH="$HOME/scoop/shims:$PATH"
