# Prepare the LXC configuration for the container
lxc_config()
{
  # Set up the container configuration
  cat > $CONTAINER_HOME/$CONTAINER_NAME/config << EOF
# Just use ubuntu includes
lxc.include = /usr/share/lxc/config/ubuntu.common.conf

# Set system arch
lxc.arch = x86_64

## Container specific configuration
# Sample loopback config
#lxc.rootfs = loop:$CONTAINER_HOME/$CONTAINER_NAME/rootdev
lxc.utsname = $CONTAINER_NAME
lxc.rootfs = $CONTAINER_HOME/$CONTAINER_NAME/rootfs

# Network configuration
# Just use host networking
# WARNING - under this configuration, signals to container init hit the host init.
lxc.network.type = none

# Enable nesting of containers
# By mounting cgroups into container and
# Using an AA profile that allows this
lxc.mount.auto = cgroup

# Allow loop devices
# http://askubuntu.com/questions/376345/allow-loop-mounting-files-inside-lxc-containers
lxc.aa_profile = unconfined #lxc-container-default-with-nesting
lxc.cgroup.devices.allow = b 7:* rwm
lxc.cgroup.devices.allow = c 10:237 rwm

EOF

}

# Set up apt sources
apt_sources()
{
  cat >> $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu trusty-updates main
EOF
}

# Set it up from scratch
bootstrap()
{
  mkdir -p $CONTAINER_HOME/$CONTAINER_NAME

  # Set up include or exclude packages
  PACKAGE_ARGS=""
  [ -n "${GLOBAL_PACKAGES}${PACKAGES}" ] && PACKAGE_ARGS="${PACKAGE_ARGS} --include=$(join , ${GLOBAL_PACKAGES} ${PACKAGES})"
  [ -n "${GLOBAL_BLACKLIST_PACKAGES}${BLACKLIST_PACKAGES}" ] && PACKAGE_ARGS="${PACKAGE_ARGS} --exclude=$(join , ${GLOBAL_BLACKLIST_PACKAGES} ${BLACKLIST_PACKAGES})"

  debootstrap "$([ -n "$DEBUG" ] && echo "--keep-debootstrap-dir")" $PACKAGE_ARGS --variant=minbase --components main,universe --arch amd64 $DISTRO $CONTAINER_HOME/$CONTAINER_NAME/rootfs $MIRROR
  lxc_config
  apt_sources
}
