# adapter from http://jondavidjohn.com/blog/2013/08/quest-for-the-perfect-git-bash-prompt-redux

_PS_GREEN="\[\e[1;32m\]"
_PS_BLUE="\[\e[1;34m\]"
_PS_RED="\[\e[1;31m\]"
_PS_PURPLE="\[\e[1;35m\]"
_PS_YELLOW="\[\e[1;33m\]"
_PS_NOCOLOR="\[\e[00m\]"

_ps_git_branch() {
  project_path=$(git rev-parse --show-toplevel 2>/dev/null) || return
  branch=$(cat $project_path/.git/HEAD | rev | cut -d/ -f1 | rev)

  if [[ $branch != "" ]]; then
    if [[ $(git status 2> /dev/null | tail -n1) == *nothing\ to\ commit* ]]; then
      echo "${_PS_GREEN}$branch${_PS_NOCOLOR} "
    else
      echo "${_PS_RED}$branch${COLROEND} "
    fi
  fi
}

_ps_working_directory() {
  current_dir=`pwd`
  project_path=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ `pwd` =~ ^"$HOME"(/|$) ]]; then
    current_dir="~${current_dir#$HOME}"
    if [ "$project_path" != "" ] ; then
      project_path="~${project_path#$HOME}"
    fi
  fi

  if [ "$project_path" != "" ] ; then
    before_project=`echo "$project_path" | rev | cut -d / -f 2- | rev`
    project_name=`basename $project_path`
    after_project="${current_dir##$project_path}"
    echo -e "${_PS_YELLOW}${before_project}/${_PS_BLUE}${project_name}${_PS_NOCOLOR}${_PS_YELLOW}${after_project}${_PS_NOCOLOR} "
  else
    echo -e "${_PS_YELLOW}$current_dir${_PS_NOCOLOR} "
  fi
}

_ps_remote_state() {
  remote_state=$(git status -sb 2> /dev/null | grep -oh "\[.*\]")
  if [[ "$remote_state" != "" ]]; then
    out="${_PS_BLUE}[${_PS_NOCOLOR}"

    if [[ "$remote_state" == *ahead* ]] && [[ "$remote_state" == *behind* ]]; then
      behind_num=$(echo "$remote_state" | grep -oh "behind [0-9]*" | grep -oh "[0-9]*$")
      ahead_num=$(echo "$remote_state" | grep -oh "ahead [0-9]*" | grep -oh "[0-9]*$")
      out="$out${_PS_RED}$behind_num${_PS_NOCOLOR},${_PS_GREEN}$ahead_num${_PS_NOCOLOR}"
    elif [[ "$remote_state" == *ahead* ]]; then
      ahead_num=$(echo "$remote_state" | grep -oh "ahead [0-9]*" | grep -oh "[0-9]*$")
      out="$out${_PS_GREEN}$ahead_num${_PS_NOCOLOR}"
    elif [[ "$remote_state" == *behind* ]]; then
      behind_num=$(echo "$remote_state" | grep -oh "behind [0-9]*" | grep -oh "[0-9]*$")
      out="$out${_PS_RED}$behind_num${_PS_NOCOLOR}"
    fi

    out="$out${_PS_BLUE}]${_PS_NOCOLOR}"
    echo "$out "
  fi
}

_my_git_prompt() {
  if [[ $? -eq 0 ]]; then
    exit_code_indicator="${_PS_BLUE}›${_PS_NOCOLOR} "
  else
    exit_code_indicator="${_PS_RED}›${_PS_NOCOLOR} "
  fi

  if type _my_prompt | grep "is a function" > /dev/null ; then
    _my_prompt
  fi

  # Customize the prompt here (\h, \u, \n, etc)
  PS1="${_PS_PURPLE}[\u@\h]${_PS_NOCOLOR} $(_ps_working_directory)$(_ps_git_branch)$(_ps_remote_state)\n $exit_code_indicator"
}

PROMPT_COMMAND=_my_git_prompt

