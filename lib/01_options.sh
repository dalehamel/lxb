reset_steps()
{
  BOOTSTRAP=
  INITIALIZE=
  PREPARE=
  USER_SETUP=
  CLEANUP=
  FINALIZE=
  EMBED=
  ISO=
}

default_steps()
{
  BOOTSTRAP=true
  INITIALIZE=true
  PREPARE=true
  USER_SETUP=true
  CLEANUP=true
  FINALIZE=true
}

parse_include()
{
  reset_steps

  for arg in `echo $1 | sed "s/,/\n/g"`; do
    case $arg in
      bootstrap) BOOTSTRAP=true ;;
      initialize) INITIALIZE=true ;;
      prepare) PREPARE=true ;;
      user) USER_SETUP=true ;;
      cleanup) CLEANUP=true ;;
      finalize) FINALIZE=true ;;
      embed) EMBED=true ;;
      iso) ISO=true ;;
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
      CONTAINER_HOME=$OPTARG
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