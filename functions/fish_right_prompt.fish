# Easy printing with foreground and background colors
function prompt_segment
  set -l bg $argv[1]
  set -l fg $argv[2]

  set_color -b $bg
  set_color $fg

  if [ -n "$argv[3]" ]
    echo -n -s $argv[3]
  end
end

function spacer
  prompt_segment normal normal " "
end

function show_pwd
  prompt_segment normal white (prompt_pwd)
end

function dirty_files_in_dir
  command git status $argv[1] -s --ignore-submodules=dirty 2>/dev/null | wc -l | sed -e 's/^ *//' -e 's/ *$//'
end

function show_git_status
  if command git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
    set -l dirty_dir (dirty_files_in_dir ".")
    set -l dirty_repo (dirty_files_in_dir ":/")
    set -l ref (command git symbolic-ref --short HEAD 2>/dev/null; or command git rev-parse --short HEAD 2>/dev/null)
    set -l local (command git rev-parse "$ref" 2>/dev/null)
    set -l remote (command git rev-parse "origin/$ref" 2>/dev/null)

    if [ "$dirty_dir" != "0" ]
      prompt_segment normal red "$ref"
    else if [ "$dirty_repo" != "0" ]
      prompt_segment normal yellow "$ref"
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

