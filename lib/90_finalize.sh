finalize()
{
  mkdir -p $CONTAINER_OUTPUT

  if [ $CONTAINER_SUPERVISOR ];then
    path="$CONTAINER_HOME/$CONTAINER_NAME/rootfs"
  else
    path="$CONTAINER_HOME/$CONTAINER_NAME"
  fi

  mksquashfs $path $CONTAINER_OUTPUT/image.squashfs -e "$(join , $GLOBAL_EXCLUDE_DIRS $EXCLUDE_DIRS)"
}
