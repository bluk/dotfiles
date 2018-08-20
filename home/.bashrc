export CLICOLOR=1
export LSCOLORS=gxfxCxDxbxegedabagacad
export EDITOR=vim
export PAGER=less

set -o vi

export DYLD_LIBRARY_PATH="/usr/local/lib/:$DYLD_LIBRARY_PATH"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

if [ -f "/usr/local//etc/bash_completion.d/git-prompt.sh" ]; then
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

alias export-credentials=". $HOME/.local_config/credentials.sh"
alias dockernotary="notary -s https://notary.docker.io -d ~/.docker/trust"
alias ll="ls -l"
alias la="ls -la"

# Add scripts

export PATH=$PATH:~/scripts
export PATH=$PATH:~/Code/bin
export PATH=$PATH:~/Applications

# Language Specific

## Java

export MAVEN_OPTS="-Xmx512M -XX:MaxPermSize=128M"
alias j10="export JAVA_HOME=`/usr/libexec/java_home -v 10`; java -version"
alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"

## Go

export GOPATH=~/Code/go
export PATH=$GOPATH/bin:$PATH

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

switch_gpg_agent_for_ssh

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

# Source local changes

if [ -f ~/.local_config/.bashrc ]; then
    source ~/.local_config/.bashrc
fi
