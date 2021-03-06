# Assorted global utility functions

# Facilitate debugging

defined()
{
  set +e
  declare -F $1 > /dev/null
  rc=$?
  set -e
  return $rc
}

# Joins a list on a delimiter
join()
{
  local IFS="$1"
  shift
  echo "$*"
}

# Helper to execute inside the system
cexec()
{
  lxc-attach -n $CONTAINER_NAME -P $CONTAINER_HOME -- $@
  return $?
}

# Helper to execute inside the system
chroot_exec()
{
  chroot $CONTAINER_HOME/$CONTAINER_NAME/rootfs $@
}

# Nukes the container for a completely fresh build
fresh()
{
  echo "Fresh build"


  if [ -n "`ps -auxf | grep lxc-start | grep $CONTAINER_NAME`" ];then
    echo "Stopping $CONTAINER_NAME"
    lxc-stop -n $CONTAINER_NAME -P $CONTAINER_HOME -k
  fi

  lxc-stop -n $CONTAINER_NAME -P $CONTAINER_HOME -k || true

  grep $CONTAINER_HOME/$CONTAINER_NAME/rootfs /etc/mtab -q && umount $CONTAINER_HOME/$CONTAINER_NAME/rootfs
  for tmp in "$(ls -1 /tmp | grep lxb)"; do
    [ -n "$tmp" ] && [ -d "/tmp/${tmp}" ] && umount "/tmp/${tmp}"
  done

  if [ -d "$CONTAINER_HOME/$CONTAINER_NAME/config" ];then
    echo "Destroying $CONTAINER_NAME"
    lxc-destroy -n $CONTAINER_NAME -P $CONTAINER_HOME
  fi

  if [ -d "$CONTAINER_HOME/$CONTAINER_NAME" ];then
    echo "Destroying $CONTAINER_HOME/$CONTAINER_NAME"
    rm -rf $CONTAINER_HOME/$CONTAINER_NAME
  fi

  if [ -d "$CONTAINER_OUTPUT" ];then
    echo "Destroying output directory"
    rm -rf  "$CONTAINER_OUTPUT"
  fi
}

start_container()
{
  # Start the container in the background
  lxc-start -n $CONTAINER_NAME -P $CONTAINER_HOME -d
}

