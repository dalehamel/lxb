# This file does most of the setup
# - Parses command line options
# - sets default build steps

reset_steps()
{
  DO_LXC_CONFIG=
  DO_INIT_ROOT=
  DO_INSTALL_PACKAGES=
  DO_USER_SETUP=
  DO_CUSTOMIZE=
  DO_CLEANUP=
  DO_FINALIZE=
  DO_EMBED=
  DO_GENERATE_ISO=
}

default_steps()
{
  DO_LXC_CONFIG=true
  DO_INIT_ROOT=true
  DO_INSTALL_PACKAGES=true
  DO_USER_SETUP=true
  DO_CUSTOMIZE=true
  DO_CLEANUP=true
  DO_FINALIZE=true
}

parse_include()
{
  reset_steps

  for arg in `echo $1 | sed "s/,/\n/g"`; do
    case $arg in
      lxc_config) DO_LXC_CONFIG=true ;;
      init_root)  DO_INIT_ROOT=true ;;
      packages)   DO_INSTALL_PACKAGES=true ;;
      user)       DO_USER_SETUP=true ;;
      customize)  DO_CUSTOMIZE=true ;;
      cleanup)    DO_CLEANUP=true ;;
      finalize)   DO_FINALIZE=true ;;
      embed)      DO_EMBED=true ;;
      iso)        DO_GENERATE_ISO=true ;;
      all) default_steps;;
    esac
  done
}

usage()
{
  cat << EOF | tee
Usage:
  -f fresh      - performs a fresh build
  -d debug      - run in verbose debug mode
  -n name       - container and config name to use
  -p path       - path to container home
  -s source     - path to source container, if any
  -i include    - CSV of stages to include (defaults to all)
    bootstrap     - bootstrap stage, sets up container
    initialize    - initialize stage, starts container
    prepare       - prepare stage, environmental setup inside container
    user          - create the admin user with password and pubkey
    custom        - custom stage, anything else
    cleanup       - cleanup stage, free up space used by cached files
    finalize      - finalize stage, create an image of the container
    embed         - embed stage, embeds the squashfs container into an initramfs
    iso           - embeds the kernel and initramfs into an ISO (not run default)
    all           - run all stages
EOF

}
# Set up default flags
DEBUG=
FRESH=

# Prepare the default steps
reset_steps
default_steps

# Parse any other options given
while getopts "ehdfn:s:p:o:i:" OPTION
do
  case $OPTION in
    e)
      EMBED=true
      ;;
    f)
      FRESH=true
      ;;
    d)
      DEBUG=true
      ;;
    n)
      CONTAINER_NAME=$OPTARG
      ;;
    p)
      PROFILE=$OPTARG
      ;;
    s)
      CONTAINER_SOURCE=$OPTARG
      ;;
    o)
      CONTAINER_OUTPUT=$OPTARG
      ;;
    i)
      INCLUDE=$OPTARG
      parse_include $INCLUDE
      ;;
    h)
      usage
      exit
      ;;
  esac
done

# Set up the config for this build
ROOT_DIR="$(dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ))"
CONFIG_PATH="${ROOT_DIR}/configs/${CONTAINER_NAME}/config"
PROFILE_PATH="${ROOT_DIR}/profiles/${PROFILE}"
LIBRARY_PATH="${ROOT_DIR}/lib"

# Load the selected config
if [ -f $CONFIG_PATH ];then
  source $CONFIG_PATH
else
  echo "A container name with a config in the ./config folder must be specified"
  exit 1
fi

if

# Load the profile for the config
if [ -f $PROFILE_PATH ];then
  for f in ${PROFILE_PATH}/*.sh; do source $f; done
else
  echo "The profile ${PROFILE} does not exist, please specify a profile at ${PROFILE_PATH}"
fi
