if [[ "$OSTYPE" == "linux-gnu" ]]; then
  gpgconf --create-socketdir || true
fi

export CLICOLOR=1
export LSCOLORS=gxfxCxDxbxegedabagacad
export EDITOR=vim
export VISUAL=vim
export PAGER=less

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

set -o vi

export DYLD_LIBRARY_PATH="/usr/local/lib/:$DYLD_LIBRARY_PATH"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f "/usr/local/etc/bash_completion.d/git-prompt.sh" ]; then
  source "/usr/local/etc/bash_completion.d/git-prompt.sh"

  export GIT_PS1_SHOWDIRTYSTATE="true"
  export GIT_PS1_SHOWUPSTREAM="verbose name"
  export GIT_PS1_SHOWCOLORHINTS=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWSTASHSTATE=1
  PROMPT_TITLE='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
  export PROMPT_COMMAND="${PROMPT_TITLE}; __git_ps1 \"[ \[\e[0;35m\]\#\[\e[m\] \[\e[0;31m\]\t\[\e[m\]:\[\e[0;36m\]\w\[\e[m\]\" \" ] \$ \";$PROMPT_COMMAND"
fi

# Aliases

alias dockernotary="notary -s https://notary.docker.io -d ~/.docker/trust"
alias cdm="cd ~/Code/monorepo"
alias spg="swift package generate-xcodeproj"
alias ll="ls -alF"
alias la="ls -la"
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Add scripts

export PATH=$PATH:~/scripts
export PATH=$PATH:~/Code/bin
export PATH=$PATH:~/Applications
export PATH=$PATH:~/.fastlane/bin

# Language Specific

## Java

export MAVEN_OPTS="-Xmx512M -XX:MaxPermSize=128M"
# alias j10="export JAVA_HOME=`/usr/libexec/java_home -v 10`; java -version"
# alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"

## Go

export GOENV_ROOT="$HOME/.goenv"
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"

export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH

## Swift

export SWIFTENV_ROOT="$HOME/.swiftenv"
export PATH="$SWIFTENV_ROOT/bin:$PATH"
eval "$(swiftenv init -)"

## Python

export WORK_ON=~/.virtualenv/

## Ruby

export NOKOGIRI_USE_SYSTEM_LIBRARIES=Y
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

## Node

export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
export PATH=$PATH:~/node_modules/.bin
export PATH=$PATH:~/.npm-global/bin

## Python

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Docker

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

# Fuzzy Finder

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function check_terraform_workspace_and_git_branch
{
  if [[ "$(terraform workspace list | grep '*' | sed 's/\* //')" == "$(git branch | grep '*' | sed 's/\* //')" ]]
  then
    if [ -z "$1" ]
    then
      echo "Script needs a command"
    fi
    $1
  else
    echo 'Switch git branches to match Terraform workspace'
  fi
}

alias tfp="check_terraform_workspace_and_git_branch 'terraform plan -out=plan.changes'"
alias tfa="check_terraform_workspace_and_git_branch 'terraform apply plan.changes'"
alias tfws='terraform workspace select $(git branch | grep "*" | sed "s/\* //")'
alias tfi="terraform init -backend-config=backend.secret.tfvars"

alias fdbstop="sudo launchctl unload -w /Library/LaunchDaemons/com.foundationdb.fdbmonitor.plist"
alias fdbstart="sudo launchctl load -w /Library/LaunchDaemons/com.foundationdb.fdbmonitor.plist"

# Source local changes

if [ -f ~/.local_config/.bashrc ]; then
    source ~/.local_config/.bashrc
fi

# Allow direnv. Needs to be near the end after prompts are set
eval "$(direnv hook bash)"
