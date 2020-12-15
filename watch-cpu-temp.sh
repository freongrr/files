#!/bin/sh

sudo powermetrics --samplers smc | while read x ; do
  if echo $x | grep -q "CPU die temperature" ; then
    TEMP=$(echo $x | sed -e 's/.*: //')
    plot.sh "$TEMP"
  fi
done


