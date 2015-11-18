# Set up apt sources
_apt_sources()
{
  cat >> $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu trusty-updates main
EOF
}

# Set up ttyS1 service so kernel will respond to IPMI
_serial_console_service()
{
  cat > $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/init/ttyS1.conf <<EOF
# ttyS1 - getty
#
# This service maintains a getty on ttyS1 from the point the system is
# started until it is shut down again.

start on stopped rc or RUNLEVEL=[12345]
stop on runlevel [!12345]

respawn

# Respawn every 10 minutes so we can verify the console is active
exec /sbin/getty -L 115200 ttyS1 vt102 -t 600
EOF
}

_sudoers()
{
  cat > $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/sudoers <<EOF
Defaults      !lecture,tty_tickets,!fqdn

# User privilege specification
root          ALL=(ALL) ALL


# Members of the group 'sysadmin' may gain root privileges
%sysadmin ALL=(ALL) NOPASSWD:ALL
# Members of the group 'admin' may gain root privileges
%admin ALL=(ALL) NOPASSWD:ALL
# Members of the group 'sudo' may gain root privileges
%sudo ALL=(ALL) NOPASSWD:ALL

#includedir /etc/sudoers.d
EOF
}

_bridge_interfaces()
{
  cat > $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/network/interfaces <<EOF
auto br0
iface br0 inet dhcp
        bridge_ports eth0
        bridge_fd 0
        bridge_maxwait 0
EOF
}

_dhcp_interfaces()
{
  cat > $CONTAINER_HOME/$CONTAINER_NAME/rootfs/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet dhcp
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
  _dhcp_interfaces
  _sudoers
  _serial_console_service
}
