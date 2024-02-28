# Minimal Fish Theme

![screenshot](screenshot.png)

The left prompt is ordinarly a single `$` character, however other characters are displayed in different vi modes and within Nix shells. It's prefixed with a red `!` upon the previous command's failure, and shows the last backgrounded process, if any.

The right prompt is your PWD in short form (`$HOME/abc/def/ghi` is shortened to `~/a/d/ghi`) and, if you're in a Git repo, the active branch with color-denoted status.

## Installation

Install with your favourite Fish package manager, for example:

```console
$ fisher install samhh/fish-minimal-theme
```
