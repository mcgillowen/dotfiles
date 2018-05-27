set -g theme_nerd_fonts yes
set -g fish_prompt_pwd_dir_length 3
set -g theme_project_dir_length 2

set -g theme_color_scheme dracula

set -x VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx PATH /usr/local/texlive/2017/bin/x86_64-darwin/ $PATH



test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

