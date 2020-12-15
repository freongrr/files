#!/bin/bash

if [ -t 1 ] ; then
  C_OFF="\x1B[0m"
  C_GRAY="\x1B[0;37m"
  C_WHITE="\x1B[1;37m"
  C_DARK_RED="\x1B[0;31m"
  C_RED="\x1B[1;31m"
  C_DARK_YELLOW="\x1B[0;33m"
  C_YELLOW="\x1B[1;33m"
  C_DARK_GREEN="\x1B[0;32m"
  C_GREEN="\x1B[1;32m"
  C_DARK_BLUE="\x1B[0;34m"
  C_BLUE="\x1B[1;34m"
fi

# TODO : params (min, max, thresholds, palette)

MAX=100
MIN=0
STEP=5

MIN_WARN=50
MIN_HIGH=75

STR="$1"
VAL=$(echo "$STR" | sed -n -e 's/^\([0-9]\+\).*/\1/p' )

if [ -z "$VAL" ] ; then
  # No numeric value
  exit 1
fi

echo -n "["

i=$STEP
while (( $i < $MAX )) ; do
  CHAR="."
  if (( $i <= $VAL )) ; then
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

echo "] $STR"

