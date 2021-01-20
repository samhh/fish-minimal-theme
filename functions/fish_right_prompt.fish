function show_pwd
  prompt_segment normal white (prompt_pwd)
end

function show_git_status
  if command git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
    set -l dirty (command git status -s --ignore-submodules=dirty 2>/dev/null | wc -l | sed -e 's/^ *//' -e 's/ *$//')
    set -l ref (command git symbolic-ref --short HEAD 2> /dev/null; or command git rev-parse --short HEAD 2>/dev/null)
    set -l local (command git rev-parse "$ref")
    set -l remote (command git rev-parse "origin/$ref")

    if [ "$dirty" != "0" ]
      prompt_segment normal red "$ref"
    else if [ "$local" != "$remote" ]
      prompt_segment normal magenta "$ref"
    else
      prompt_segment normal green "$ref"
    end

    spacer
  end
end

function fish_right_prompt
  show_git_status
  show_pwd
end

