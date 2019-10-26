# Fish

set -lx SCRIPT_DIR (dirname (status --current-filename))

function fish_greeting; end

set -g fish_prompt_pwd_dir_length 1

for snippet in $SCRIPT_DIR/configurations/*
  source $snippet
end
