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
#lxc.network.type = none # WARNING - under this configuration, signals to container init hit the host init.
lxc.network.type = veth
lxc.network.flags = up

## that's the interface defined above in host's interfaces file
lxc.network.link = br0

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

lxc_wait_network()
{
  MAX_RETRIES=6
  retries=0
  echo "Waiting for network"
  while [ -z "$(cexec ip route | grep 'default' | awk '{print $3}')" ];do
    ip="$(cexec ip route | grep 'default' | awk '{print $3}')"
    if [ -n "${ip}" ];then
      cexec ping -t 1 -c 1 ${ip} > /dev/null
      [ $? -eq 0 ] && break
    fi
    retries=$[$retries +1]
    if [ $retries -gt $MAX_RETRIES ];then
      echo "Network failed to come up"
      exit 1
    fi
    sleep 5
  done
  echo "Network is up"
}
