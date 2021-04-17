# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/bryantluk/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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

set -o vi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  cargo
  direnv
  docker
  ember-cli
  git
  heroku
  jsontools
  node
  rust
  rustup
  tmux
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'

export CLICOLOR=1
export LSCOLORS='gxfxCxDxbxegedabagacad'
export VISUAL='vim'
export PAGER='less'
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Set OSTYPE
if [ -z "$OSTYPE" ]; then
  export OSTYPE (zsh -c 'echo ${OSTYPE}')
fi

if [ "$OSTYPE" = "linux-gnu" ]; then
  gpgconf --create-socketdir || true
fi

# Commented out due to VS Code
# export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias dockernotary="notary -s https://notary.docker.io -d ~/.docker/trust"
alias cdm="cd ~/Code/monorepo"
alias spg="swift package generate-xcodeproj"
alias ll="ls -alF"
alias la="ls -la"
alias l="ls -CF"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:$HOME/Code/bin:$HOME/Applications:$HOME/.fastlane/bin

# Language Specific

## Java

export MAVEN_OPTS="-Xmx512M -XX:MaxPermSize=128M"
# alias j10="set -gx JAVA_HOME (/usr/libexec/java_home -v 10); java -version"
# alias j8="set -gx JAVA_HOME (/usr/libexec/java_home -v 2.8); java -version"

## Go

# export GOENV_ROOT=$HOME/.goenv
# export PATH=$HOME/.goenv/bin:$PATH
# eval "$(goenv init -)"

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

## Swift

# set -gx SWIFTENV_ROOT "$HOME/.swiftenv"
# set -gx PATH $SWIFTENV_ROOT/bin $PATH
# if which swiftenv > /dev/null
#   status --is-interactive
#   and source (swiftenv init - | psub)
# end
#
# # set -gx PATH $PATH $HOME/provision/sourcekit-lsp/.build/x86_64-apple-macosx/debug
# # set -gx SOURCEKIT_TOOLCHAIN_PATH /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2019-02-14-a.xctoolchain/

## Python

# set -gx WORK_ON ~/.virtualenv/
# set -gx PATH "$HOME/.pyenv/bin" $PATH
# if which pyenv > /dev/null
#   status --is-interactive
#   and source (pyenv init - | psub)
#   and source (pyenv virtualenv-init - | psub)
# end

## Ruby

export NOKOGIRI_USE_SYSTEM_LIBRARIES="Y"
# export PATH=$HOME/.rbenv/bin:$PATH
# eval "$(rbenv init -)"

## Rust

export PATH=$HOME/.cargo/bin:$PATH

## Docker

export DOCKER_CONTENT_TRUST=1

# Switch to GPG Agent for SSH

function switch_gpg_agent_for_ssh
{
  # Launch gpg-agent with ssh agent
  gpg-connect-agent /bye

  # Point the SSH_AUTH_SOCK to the one handled by gpg-agent
  if [ -S $HOME/.gnupg/S.gpg-agent.ssh ]; then
    if [ -z "$OLD_SSH_AUTH_SOCK" ]; then
      export OLD_SSH_AUTH_SOCK=$SSH_AUTH_SOCK
    fi
    export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
  elif [ -S "/run/user/${UID}/gnupg/S.gpg-agent.ssh" ]; then
    if [ -z "$OLD_SSH_AUTH_SOCK" ]; then
      export OLD_SSH_AUTH_SOCK=$SSH_AUTH_SOCK
    fi
    export SSH_AUTH_SOCK="/run/user/${UID}/gnupg/S.gpg-agent.ssh"
  else
    echo "$HOME/.gnupg/S.gpg-agent.ssh doesn't exist. Is gpg-agent running ?"
  fi
}

function switch_ssh_agent_for_ssh
{
  if [ -n "$OLD_SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$OLD_SSH_AUTH_SOCK
  fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  switch_gpg_agent_for_ssh
fi

# alias tfp "check_terraform_workspace_and_git_branch 'terraform plan -out=changes.tfplan'"
# alias tfa "check_terraform_workspace_and_git_branch 'terraform apply changes.tfplan'"
# alias tfws 'terraform workspace select (git branch | grep "*" | sed "s/\* //")'
# alias tfi "terraform init -backend-config=backend.secret.tfvars"
#
# alias fdbstop "sudo launchctl unload -w /Library/LaunchDaemons/com.foundationdb.fdbmonitor.plist"
# alias fdbstart "sudo launchctl load -w /Library/LaunchDaemons/com.foundationdb.fdbmonitor.plist"

# FZF
export PATH=$HOME/.fzf/bin:$PATH

# Allow direnv. Needs to be near the end after prompts are set
eval "$(direnv hook zsh)"

export PATH=$HOME/.local/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH

# function set_win_title(){
#     echo -ne "\033]0; YOUR_WINDOW_TITLE_HERE \007"
# }
# precmd_functions+=(set_win_title)
eval "$(starship init zsh)"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
