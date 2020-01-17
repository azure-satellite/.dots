function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l tokens

    # NIX shell
    if set -q IN_NIX_SHELL
        if not set -q NIX_SHELL_NAME
            set -gx NIX_SHELL_NAME (basename $PWD)
        end
        set tokens $tokens (set_color $fish_color_host --bold)"NIX:"$NIX_SHELL_NAME(set_color normal)
    else
        if set -q NIX_SHELL_NAME
            set -e NIX_SHELL_NAME
        end
    end

    # Current working directory
    set -l color_cwd $fish_color_cwd
    if test "$USER" = "root"; set color_cwd $fish_color_cwd_root; end
    set tokens $tokens (set_color $color_cwd)(prompt_pwd)(set_color normal)

    set -l branch (command git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if test "$status" = 0
        set -l git_stats ""

        command git diff-index --no-ext-diff --ignore-submodules --diff-algorithm=default --quiet --cached HEAD
        if test "$status" != 0
            set git_stats $git_stats(set_color green --bold)"*"(set_color normal)
        end

        # Will take longer on a cold run
        command git diff-files --no-ext-diff --ignore-submodules --diff-algorithm=default --quiet
        if test "$status" != 0
            set git_stats $git_stats(set_color red --bold)"*"(set_color normal)
        end

        set tokens $tokens (set_color $fish_color_user)$branch(set_color normal)$git_stats
    end

    # Error code
    set -l error ""
    if test $last_status -ne 0
        set tokens $tokens (set_color red --bold)"$last_status"(set_color normal)
    end

    # Print the prompt
    echo -s (set_color $fish_color_prompt --bold)"["(set_color normal)(string join " " $tokens)(set_color $fish_color_prompt --bold)"]: "(set_color normal)
end
