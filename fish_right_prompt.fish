function show_pwd
  prompt_segment normal white (prompt_pwd)
end

function show_git_status
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set -l dirty (command git status -s --ignore-submodules=dirty | wc -l | sed -e 's/^ *//' -e 's/ *$//' 2> /dev/null)
    set -l ref (command git symbolic-ref --short HEAD 2> /dev/null ; or command git rev-parse --short HEAD 2> /dev/null)

    if [ "$dirty" = "0" ]
      prompt_segment normal green "$ref"
    else
      prompt_segment normal red "$ref"
    end

    spacer
   end
end

function fish_right_prompt
  show_git_status
  show_pwd
end

