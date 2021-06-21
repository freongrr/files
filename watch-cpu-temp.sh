#!/bin/bash

# Note: this assumes "echo" is the GNU version (i.e. installed with Brew)

if [ -t 1 ] ; then
  C_OFF="\x1B[0m"
  C_RED="\x1B[1;31m"
  C_YELLOW="\x1B[1;33m"
  C_GREEN="\x1B[1;32m"
fi

MAX=100
MIN=0
STEP=5

MIN_WARN=50
MIN_HIGH=75

plot() {
  local strVal="$1"
  local numVal=$(echo "$strVal" | sed -n -e 's/^\([0-9]\+\).*/\1/p' )

  echo -n "["

  i=$STEP
  while (( $i < $MAX )) ; do
    CHAR="."
    if (( $i <= $numVal )) ; then
      CHAR="#"
    fi

    if (( $i > $MIN_HIGH )) ; then
      echo -en "${C_RED}${CHAR}${C_OFF}"
    elif (( $i > $MIN_WARN )) ; then
      echo -en "${C_YELLOW}${CHAR}${C_OFF}"
    else
      echo -en "${C_GREEN}${CHAR}${C_OFF}"
    fi

    i=$[$i+$STEP]
  done

  echo "] $strVal"
}

sudo powermetrics --samplers smc | while read x ; do
  if echo $x | grep -q "CPU die temperature" ; then
    TEMP=$(echo $x | sed -e 's/.*: //')
    plot "$TEMP"
  fi
done


