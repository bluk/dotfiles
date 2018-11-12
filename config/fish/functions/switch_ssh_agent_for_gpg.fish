function switch_ssh_agent_for_gpg --description="Switch to the SSH agent"
  if set -q OLD_SSH_AUTH_SOCK
    set -gx SSH_AUTH_SOCK $OLD_SSH_AUTH_SOCK
  end
end
