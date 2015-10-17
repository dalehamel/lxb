#!/bin/bash
#
# Sets up an LXC image

# Don't allow any errors
set -e

# Import sources in lexical order
for f in lib/*.sh; do source $f; done

# Parse options
while getopts “dfn:s:h:” OPTION
do
  case $OPTION in
    f)
      FRESH=true
      ;;
    d)
      DEBUG=true
      ;;
    n)
      CONTAINER_NAME=$OPTARG
      ;;
    h)
      CONTAINER_HOME=$OPTARG
      ;;
    s)
      CONTAINER_SOURCE=$OPTARG
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

main()
{
  [ $DEBUG ] && debug
  [ $FRESH ] && fresh
  [ $BOOTSTRAP ] && bootstrap
  [ $INITIALIZE ] && initialize
  [ $PREPARE ] && prepare
  [ $CLEANUP ] && cleanup
  [ $FINALIZE ] && finalize
}

main
