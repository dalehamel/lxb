parse_include()
{
  reset_steps

  for arg in `echo $1 | sed "s/,/\n/g"`; do
    case $arg in
      bootstrap) BOOTSTRAP=true ;;
      initialize) INITIALIZE=true ;;
      prepare) PREPARE=true ;;
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
    custom        - custom stage, anything else
    cleanup       - cleanup stage, free up space used by cached files
    finalize      - finalize stage, create an image of the container
    embed         - embed stage, embeds the squashfs container into an initramfs
    all           - run all stages
EOF

}

# Parse options
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

