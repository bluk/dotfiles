set -g __fish_git_prompt_showdirtystate 'true'
set -g __fish_git_prompt_showupstream verbose
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_showuntrackedfiles 'yes'
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_describe_style 'contains'
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_char_stateseparator "|"

function fish_prompt --description 'Write out the prompt'
	  # Save the return status of the previous command
    set stat $status

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_color_blue
        set -g __fish_color_blue (set_color -o blue)
    end

    if not set -q __fish_color_magenta
        set -g __fish_color_magenta (set_color -o magenta)
    end

    # Set the color for the status depending on the value
    set __fish_color_status (set_color -o green)
    if test $stat -gt 0
        set __fish_color_status (set_color -o red)
    end

    switch "$USER"
        case root toor
            if not set -q __fish_prompt_cwd
                if set -q fish_color_cwd_root
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
                else
                    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
                end
            end

            printf '%s@%s %s%s%s# ' $USER (prompt_hostname) "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal"

        case '*'

            if not set -q __fish_prompt_cwd
                # set -g __fish_prompt_cwd (set_color $fish_color_cwd)
                set -g __fish_prompt_cwd (set_color cyan)
                # bright_magenta for the command number
            end

            # printf '[%s %s%s@%s %s%s %s(%s)%s \f\r] $' (date "+%H:%M:%S") "$__fish_color_blue" $USER (prompt_hostname) "$__fish_prompt_cwd" "$PWD" "$__fish_color_status" "$stat" "$__fish_prompt_normal"
            printf '[%s%s%s:%s%s%s - %s(%s)%s] $ ' (set_color brred) (date "+%H:%M:%S") "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" (__fish_git_prompt) "$__fish_color_status" "$stat" "$__fish_prompt_normal"

    end
end
