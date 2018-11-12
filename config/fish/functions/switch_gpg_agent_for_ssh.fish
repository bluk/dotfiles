function switch_gpg_agent_for_ssh --description="Switch to GPG Agent for SSH"
  # Launch gpg-agent with ssh agent
  gpg-connect-agent /bye

  set UID (bash -c 'echo ${UID}')

  # Point the SSH_AUTH_SOCK to the one handled by gpg-agent
  if test -S $HOME/.gnupg/S.gpg-agent.ssh
    if not set -q OLD_SSH_AUTH_SOCK
      set -gx OLD_SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    end
    set -gx SSH_AUTH_SOCK "$HOME/.gnupg/S.gpg-agent.ssh"
  else if test -S "/run/user/$UID/gnupg/S.gpg-agent.ssh"
    if not set -q OLD_SSH_AUTH_SOCK
      set -gx OLD_SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
    end
    set -gx SSH_AUTH_SOCK "/run/user/$UID/gnupg/S.gpg-agent.ssh"
  else
    echo "$HOME/.gnupg/S.gpg-agent.ssh doesn't exist. Is gpg-agent running?"
  end
end
