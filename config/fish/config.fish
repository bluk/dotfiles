set -gx CLICOLOR 1
set -gx CLICOLOR_FORCE 1
set -gx LSCOLORS gxfxCxDxbxegedabagacad
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER less
set -gx fish_greeting ""
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Set OSTYPE
if not set -q OSTYPE
    set -gx OSTYPE (bash -c 'echo ${OSTYPE}')
end

set -g fish_key_bindings hybrid_bindings

if test $OSTYPE = "linux-gnu"
  gpgconf --create-socketdir; or true
end

set -gx DYLD_LIBRARY_PATH /usr/local/lib:$DYLD_LIBRARY_PATH

# Aliases

alias dockernotary "notary -s https://notary.docker.io -d ~/.docker/trust"
alias cdm "cd ~/Code/monorepo"
alias spg "swift package generate-xcodeproj"
alias ll "ls -alF"
alias la "ls -la"
alias l 'ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert 'notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Add scripts

set -gx PATH $PATH ~/Code/bin ~/Applications ~/.fastlane/bin

# Language Specific

# set -gx PATH /usr/local/anaconda3/bin/ $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/bryantluk/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

## Java

set -gx MAVEN_OPTS "-Xmx512M -XX:MaxPermSize=128M"
alias j10 "set -gx JAVA_HOME (/usr/libexec/java_home -v 10); java -version"
alias j8 "set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8); java -version"

## Go

set -gx GOENV_ROOT "$HOME/.goenv"
# set -gx PATH "$HOME/.goenv/bin" $PATH
# if which goenv > /dev/null
#   status --is-interactive
#   and source (goenv init - | psub)
# end

set -gx GOPATH ~/go
set -gx PATH "$GOPATH/bin" $PATH

## Swift

set -gx SWIFTENV_ROOT "$HOME/.swiftenv"
# set -gx PATH $SWIFTENV_ROOT/bin $PATH
# if which swiftenv > /dev/null
#   status --is-interactive
#   and source (swiftenv init - | psub)
# end

## Python

set -gx WORK_ON ~/.virtualenv/

## Ruby

set -gx NOKOGIRI_USE_SYSTEM_LIBRARIES Y
# set -gx PATH "$HOME/.rbenv/bin" $PATH
# if which rbenv > /dev/null
#   status --is-interactive
#   and source (rbenv init - | psub)
# end

## Rust
#
set -gx PATH "$HOME/.cargo/bin" $PATH

## Docker

set -gx DOCKER_CONTENT_TRUST 1

if string match -i -q "darwin*" $OSTYPE; and test $status -eq 0
  switch_gpg_agent_for_ssh
end

alias tfp "check_terraform_workspace_and_git_branch 'terraform plan -out=changes.tfplan'"
alias tfa "check_terraform_workspace_and_git_branch 'terraform apply changes.tfplan'"
alias tfws 'terraform workspace select (git branch | grep "*" | sed "s/\* //")'
alias tfi "terraform init -backend-config=backend.secret.tfvars"

alias fdbstop "sudo launchctl unload -w /Library/LaunchDaemons/com.foundationdb.fdbmonitor.plist"
alias fdbstart "sudo launchctl load -w /Library/LaunchDaemons/com.foundationdb.fdbmonitor.plist"

# FZF
set -gx PATH "$HOME/.fzf/bin" $PATH

# Fish Start Preexec Time
set -g fish_command_start_preexec_color brcyan
set -g fish_command_start_preexec_time_format "%H:%M:%S"

# Fish Command Timer
set -g fish_command_timer_color brcyan
set -g fish_command_timer_time_format "%H:%M:%S"

if test -e "$HOME/.local_config/local.fish"
  source "$HOME/.local_config/local.fish"
end

# Allow direnv. Needs to be near the end after prompts are set
eval (direnv hook fish)

set -gx PATH "$HOME/.local/bin" "$HOME/.cabal/bin" "$HOME/.ghcup/bin" $PATH
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
