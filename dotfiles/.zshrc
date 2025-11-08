# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# ====== Zsh startup (interactive guard)
[[ $- != *i* ]] && return

# ====== PATH
export PATH="$HOME/.local/bin:$PATH"

# ====== History (larger, deduped, shared across sessions)
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY          # append rather than overwrite
setopt SHARE_HISTORY           # share history across sessions
setopt EXTENDED_HISTORY        # timestamps etc.
setopt HIST_IGNORE_SPACE       # don't record commands starting with space
setopt HIST_IGNORE_ALL_DUPS    # remove older duplicate commands
setopt HIST_EXPIRE_DUPS_FIRST  # expire dups first
setopt HIST_FIND_NO_DUPS       # don't show dups in search

# ====== Completion (native zsh)
autoload -Uz compinit
compinit

# If you rely on a *bash* completion (your ripgrep file), enable bashcomp compat
if [ -f "$HOME/.config/bash_completion/rg.bash" ]; then
  autoload -Uz bashcompinit
  bashcompinit
  source "$HOME/.config/bash_completion/rg.bash"
fi

# ====== Friendly globbing and dotfile behavior
setopt EXTENDED_GLOB
setopt GLOB_DOTS   # allow * to match dotfiles (like bash's "dotglob" idea)

# ====== Colors + common GNU utils aliases
if command -v dircolors >/dev/null 2>&1; then
  test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Make less handle non-text nicely
if [ -x /usr/bin/lesspipe ]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

# ====== Quality-of-life
setopt AUTO_CD     # "cd" by typing a directory name
setopt CORRECT     # mild command correction (shows a suggestion)

# ====== Your aliases & functions (ported from .bashrc)

# ls shortcuts
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Simple cd shortcut
goplat() { cd "$HOME/projects/Platform-Automation"; }

# Git aliases
alias gcl='git clone'
alias gpr='gh pr checkout'
alias gco='git checkout'
alias gg='git pull'
alias gp='git push'
alias gs='git status'
alias grh='git reset --hard'
alias grs='git reset --soft'

# git commit with message
alias gcm='git commit -m'
# Cargo shortcuts
alias cb='cargo build'
alias cr='cargo run'
alias cc='cargo check'
alias ct='cargo test'

# Exit shell
alias xx='exit'

# Sync Fork (kept logic; made branch var local)
syncfork() {
  local currentBranch
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  git stash push -m "Auto-stash before sync" >/dev/null 2>&1
  git fetch upstream
  git checkout master
  git merge upstream/master
  git push origin master
  git checkout "$currentBranch"
  git stash pop >/dev/null 2>&1
}
alias syncfork='syncfork'

# "alert" for long-running commands (zsh-friendly: use `fc` to get last cmd)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(fc -ln -1 | sed -e "s/^[[:space:]]*//;s/[;&|][[:space:]]*alert$//")"'

# Source extra aliases if you keep them separately
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# ====== Prompt: Starship (recommended; you already use it)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ====== Oh My Zsh + Plugins (optional but recommended for autosuggestions)

# If Oh My Zsh is installed, load it and plugins
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME=""   # using Starship for the prompt
  plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf-tab
  )
  source "$ZSH/oh-my-zsh.sh"

  # Autosuggestions tuning (ghost text color)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
fi

# Fallback: if plugins are cloned but OMZ isn't sourced, load them directly
# (no-op if not present)
[[ -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Optional: handy keybinding to accept autosuggestion with Ctrl+E
if typeset -f _zsh_autosuggest_bind_widgets >/dev/null 2>&1; then
  bindkey '^E' autosuggest-accept
fi
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
