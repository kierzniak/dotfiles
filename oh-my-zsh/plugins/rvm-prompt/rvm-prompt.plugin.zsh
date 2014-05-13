ZSH_THEME_RVM_PROMPT_PREFIX="[ %{$fg_bold[blue]%}"
ZSH_THEME_RVM_PROMPT_SUFFIX="%{$reset_color%} ]"

function ruby_version()
{
    typeset -g ruby_version=''
    if which rvm-prompt &> /dev/null; then
      ruby_version="${ZSH_THEME_RVM_PROMPT_PREFIX}$(rvm-prompt i v g)${ZSH_THEME_RVM_PROMPT_SUFFIX}"
      echo $ruby_version
    else
      if which rbenv &> /dev/null; then
        ruby_version="$(rbenv version | sed -e "s/ (set.*$//")"
        echo $ruby_version
      fi
    fi
}