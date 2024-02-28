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

# The `$IN_NIX_SHELL` environment variable isn't set in a `nix shell` proper,
# hence this workaround of checking the `$PATH`.
#   https://discourse.nixos.org/t/in-nix-shell-env-variable-in-nix-shell-versus-nix-shell/15933
#   https://github.com/NixOS/nix/issues/3862#issuecomment-707320241
function is_nix_shell
  echo $PATH | grep -q /nix/store
end

function is_vi_mode
  test $fish_key_bindings = "fish_vi_key_bindings"
end

function show_def_prompt
  if is_nix_shell
    prompt_segment normal white "λ"
  else
    prompt_segment normal white "\$"
  end
end

function show_prompt
  if is_vi_mode
    switch $fish_bind_mode
      case default
        prompt_segment normal blue "·"
      case insert
        show_def_prompt
      case replace_one replace-one
        prompt_segment normal green "r"
      case visual
        prompt_segment normal yellow "v"
    end
  else
    show_def_prompt
  end
end

# Display status if previous command returned an error
function show_status
  if [ $RETVAL -ne 0 ]
    prompt_segment normal red "!"
    spacer
  end
end

# Display the most recently backgrounded job, if any
function show_bg
  if jobs -q
    set -l cmd (jobs -lc | sed -n 1p)

    prompt_segment normal brblack "($cmd)"
    spacer
  end
end

function fish_prompt
  set -g RETVAL $status
  show_status
  show_bg
  show_prompt
  spacer
end

