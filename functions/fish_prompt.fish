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

function show_vi_mode_prompt
  [ "$theme_display_vi" != 'no' ]; or return
  [ "$fish_key_bindings" = 'fish_vi_key_bindings' \
    -o "$fish_key_bindings" = 'hybrid_bindings' \
    -o "$fish_key_bindings" = 'fish_hybrid_key_bindings' \
    -o "$theme_display_vi" = 'yes' ]; or return
  switch $fish_bind_mode
    case default
      prompt_segment normal blue "·"
    case insert
      if is_nix_shell
        prompt_segment normal white "λ"
      else
        prompt_segment normal white "\$"
      end
    case replace_one replace-one
      prompt_segment normal green "r"
    case visual
      prompt_segment normal yellow "v"
  end
end

# Display status if previous command returned an error
function show_status
  if [ $RETVAL -ne 0 ]
    prompt_segment normal red "!"
    spacer
  end
end

function fish_prompt
  set -g RETVAL $status
  show_status
  show_vi_mode_prompt
  spacer
end

