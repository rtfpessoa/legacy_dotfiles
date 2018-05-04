# Fish

set -lx SCRIPT_DIR (dirname (status --current-filename))

function fish_greeting; end
# function fish_greeting
#   set_color $fish_color_autosuggestion
#   fortune -a
#   set_color normal
# end
# function fish_right_prompt; end

# set -g default_user your_normal_user
set -g fish_prompt_pwd_dir_length 1

for snippet in $SCRIPT_DIR/configurations/*
  source $snippet
end
