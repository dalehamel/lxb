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
lxc.aa_profile = lxc-container-default-with-nesting
EOF

}

# Set up apt sources
apt_sources()
{
  cat > $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu trusty main
deb http://archive.ubuntu.com/ubuntu trusty universe
deb http://archive.ubuntu.com/ubuntu trusty-updates main
EOF
}

# Set it up from scratch
bootstrap()
{
  mkdir -p $CONTAINER_HOME/$CONTAINER_NAME
  debootstrap --include=lxc,openssh-server --variant=minbase --arch amd64 trusty $CONTAINER_HOME/$CONTAINER_NAME/rootfs http://archive.ubuntu.com/ubuntu/
  lxc_config
  apt_sources
}
