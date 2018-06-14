#!/usr/bin/env bash
# Nagios Exit Codes
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

usage()
{
cat <<EOF
Check size of zookeeper snapshot
  Options:
    -c        Critical threshold as an integer
    -w        Warning threshold as an integer
Usage: check_snapshot.sh -w 800 -c 1000
EOF
}

argcheck() {
# if less than n argument
if [ $ARGC -lt $1 ]; then
  echo "Missing arguments! Use \`\`-h'' for help."
  exit 1
fi
}

# Define now to prevent expected number errors
CRIT=0
WARN=0
SIZE=0
ARGC=$#
CHECK=0

argcheck 1 

while getopts "hc:s:f:p:w:e" OPTION
do
  case $OPTION in
    h)
      usage
      ;;
    s)
      STATE="$OPTARG"
      CHECK=1
      ;;
    f)
      FILTER="$OPTARG"
      CHECK=1
      ;;
    p)
      if [[ $OPTARG == tcp ]]; then
        PROTOCOL="-t"
      elif [[ $OPTARG == udp ]]; then
        PROTOCOL="-u"
      elif [[ $OPTARG == inet ]]; then
        PROTOCOL="-4"
      elif [[ $OPTARG == inet6 ]]; then
        PROTOCOL="-6"
      else
        echo "Error: Protocol or family type no valid!"
      exit 1
      fi
      CHECK=1
      ;;
    c)
      CRIT="$OPTARG"
      CHECK=1
      ;;
    w)
      WARN="$OPTARG"
      CHECK=1
      ;;
  e)
    EXACT=1
    ;;
    \?)
      exit 1
      ;;
  esac
done

SIZE=$(( ($(ls -ltr /var/lib/zookeeper/version-2/snap*|tail -1|awk '{print $5}')/1024)/1024 ))

if [ $SIZE -gt $CRIT ]; then
  echo "Zk Snapshot size is: $SIZE | SSIZE=$SIZE;;;; SWARN=$WARN;;;; SCRITICAL=$CRIT;;;;"
  $(exit 2)
elif [ $SIZE -gt $WARN ]; then
  echo "Zk Snapshot size is: $SIZE | SSIZE=$SIZE;;;; SWARN=$WARN;;;; SCRITICAL=$CRIT;;;;"
  $(exit 1)
else
  echo "Zk Snapshot size is: $SIZE | SSIZE=$SIZE;;;; SWARN=$WARN;;;; SCRITICAL=$CRIT;;;;"
  $(exit 0)
fi