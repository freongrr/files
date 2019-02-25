#!/bin/bash

# TODO : used by env script
set_term_title() {
  TERM_TITLE=$1
}

### Fancy prompt ###

_my_prompt() {
  C_GREEN='\e[1;92m'
  C_RED='\e[1;91m'
  C_OFF='\e[0m'

  export PS1="\u@$C_GREEN\h$C_OFF:\w\n\$ "

  ACTUAL_TITLE=""

  if [ -n "$TERM_TITLE" ] ; then
    ACTUAL_TITLE="$TERM_TITLE"
  else
    if [ -n "$SSH_TTY" ] ; then
      SHORT_HOSTNAME=${HOSTNAME%%.*}
      ACTUAL_TITLE="$environment - $SHORT_HOSTNAME"
    fi

    if [ "$PWD" != "$HOME" ] ; then
      SHORT_PWD=$(basename "$PWD")
      if [ -z "$ACTUAL_TITLE" ] ; then
        ACTUAL_TITLE="$SHORT_PWD"
      else
        ACTUAL_TITLE="$ACTUAL_TITLE - $SHORT_PWD"
      fi
    fi
  fi

  echo -ne "\033]0;$ACTUAL_TITLE\007"
}

### Aliases ###

if [[ "$OSTYPE" == *darwin* && $(which ls) == "/bin/ls" ]] ; then
  alias ls="ls -G"
elif [[ $(which ls) == "/usr/local/opt/coreutils/libexec/gnubin/ls" ]] ; then
  alias ls="ls --color"
fi

alias ll='ls -l'
alias lll='ls -alFtr'

PROMPT_COMMAND=_my_prompt

