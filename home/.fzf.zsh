# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/bryantluk/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/bryantluk/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/bryantluk/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/bryantluk/.fzf/shell/key-bindings.zsh"

