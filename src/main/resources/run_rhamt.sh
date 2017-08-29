#!/bin/bash


## Increase the open file limit if low, to what we need or at least to the hard limit.
## Complain if the hard limit is lower than what we need.
WE_NEED=1024
MAX_HARD=$(ulimit -H -n);
MAX_SOFT=$(ulimit -S -n);

if [ $MAX_SOFT == 'unlimited' ] ; then MAX_SOFT=$WE_NEED; fi;
if [ $MAX_HARD == 'unlimited' ] ; then MAX_HARD=$WE_NEED; fi;

if [ $MAX_SOFT -lt $WE_NEED ] || [ $MAX_HARD -lt $WE_NEED ]  ; then

  echo ""
  echo "[WARNING] The limits ($MAX_SOFT/$MAX_HARD) for open files is too low and could make RHAMT unstable. Please increase them to at least $WE_NEED."
  echo ""
  echo "    {RHEL & Fedora} Limits are typically configured in /etc/security/limits.conf"
  echo "     -> Follow instructions of https://access.redhat.com/solutions/60746"
  echo ""
  echo "    {MacOS} Limits are typically configured in /etc/launchd.conf or /etc/sysctl.conf."
  echo "     -> Execute this script: https://gist.github.com/Maarc/d13b1e70f191d5b527a24d39dd3e2569 ... and restart your operating system."
  echo ""

fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export JBOSS_HOME=$DIR

if [ -z "$WINDUP_DATA_DIR" ] ; then
    export WINDUP_DATA_DIR=$DIR/standalone/data
fi

$DIR/bin/standalone.sh -c standalone-full.xml -Dwindup.data.dir=$WINDUP_DATA_DIR $@
