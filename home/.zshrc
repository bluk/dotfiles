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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

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

export GOENV_ROOT=$HOME/.goenv
export PATH=$HOME/.goenv/bin:$PATH
eval "$(goenv init -)"
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
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

## Node

export PATH=$HOME/.nodenv/bin:$PATH
eval "$(nodenv init -)"
export PATH=$HOME/.node_modules/bin:$PATH
export PATH=$HOME/.npm-global/bin:$PATH

## Rust

export PATH=$HOME/.cargo/bin:$PATH

## Docker

export DOCKER_CONTENT_TRUST=1

# if string match -i -q "darwin*" $OSTYPE; and test $status -eq 0
#   switch_gpg_agent_for_ssh
# end
#
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

# set -gx PATH "$HOME/.local/bin" "$HOME/.cabal/bin" "$HOME/.ghcup/bin" $PATH
export PATH=$HOME/.local/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH
