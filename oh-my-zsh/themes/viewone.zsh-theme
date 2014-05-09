ZSH_THEME_GIT_PROMPT_PREFIX="[ %{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%} !%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green] %}✓%{$reset_color%}"

ZSH_THEME_RVM_PROMPT_PREFIX="[ %{$fg_bold[blue]%}"
ZSH_THEME_RVM_PROMPT_SUFFIX="%{$reset_color%} ]"

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  INPUT_COLOR=$fg[red]
else
  INPUT_COLOR=$fg[blue]
fi

PROMPT='%{$fg[green]%}<<<%{${reset_color}%} %~ %{$(ruby_version)%} %{$(git_prompt_info)%}
%{$fg[green]%}<<<%{${reset_color}%} %n@%m%{$fg_bold[red]%}!%{${reset_color}%}%# 
%{$INPUT_COLOR%}>>>%{${reset_color}%} '

# Of course we need a matching continuation prompt
PROMPT2='%{$INPUT_COLOR%}>>>%{${reset_color}%}'
