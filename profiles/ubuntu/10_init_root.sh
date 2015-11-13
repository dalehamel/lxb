# Set up apt sources
_apt_sources()
{
  cat >> $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu trusty-updates main
EOF
}

# Set it up from scratch
init_root()
{
  mkdir -p $CONTAINER_HOME/$CONTAINER_NAME

  # Set up include or exclude packages
  PACKAGE_ARGS=""
  [ -n "${GLOBAL_PACKAGES}${PACKAGES}" ] && PACKAGE_ARGS="${PACKAGE_ARGS} --include=$(join , ${GLOBAL_PACKAGES} ${PACKAGES})"
  [ -n "${GLOBAL_BLACKLIST_PACKAGES}${BLACKLIST_PACKAGES}" ] && PACKAGE_ARGS="${PACKAGE_ARGS} --exclude=$(join , ${GLOBAL_BLACKLIST_PACKAGES} ${BLACKLIST_PACKAGES})"
  debootstrap $([ -n "$DEBUG" ] && echo "--keep-debootstrap-dir" ) $PACKAGE_ARGS --variant=minbase --components main,universe --arch amd64 $DISTRO $CONTAINER_HOME/$CONTAINER_NAME/rootfs $MIRROR
  _apt_sources
}
