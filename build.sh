#!/bin/bash
#
# Sets up an LXC image

# Don't allow any errors
set -e

# Import sources in lexical order
for f in lib/*.sh; do source $f; done

main()
{
  [ $DEBUG ] && debug
  [ $FRESH ] && fresh
  [ $BOOTSTRAP ] && bootstrap
  [ $INITIALIZE ] && initialize
  [ $PREPARE ] && prepare
  [ $CLEANUP ] && cleanup
  [ $FINALIZE ] && finalize
  [ $EMBED ] && embed
}

main
