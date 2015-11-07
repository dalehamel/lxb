#!/bin/bash
#
# Sets up an LXC image

# Don't allow any errors
set -e

# Import sources in lexical order
for f in lib/*.sh; do source $f; done

# Set up the config for this build
config="configs/$CONTAINER_NAME"

if [ -f $config ];then
  source $config
else
  echo "A container name with a config in the ./config folder must be specified"
  exit 1
fi

main()
{
  [ $DEBUG ] && debug
  [ $FRESH ] && fresh
  [ $BOOTSTRAP ] && bootstrap
  [ $INITIALIZE ] && initialize
  [ $PREPARE ] && prepare
  [ $USER_SETUP ] && user_setup
  [ $CLEANUP ] && cleanup
  [ $FINALIZE ] && finalize
  [ $EMBED ] && embed
  [ $ISO ] && generate_iso
}

main
