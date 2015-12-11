finalize()
{
  cexec locale-gen en_US.UTF-8
  mkdir -p $CONTAINER_OUTPUT

  # Make the root the real root if it's to be embedded
  if [ $DO_EMBED ];then
    path="$CONTAINER_HOME/$CONTAINER_NAME/rootfs"
  else
    path="$CONTAINER_HOME/$CONTAINER_NAME"
  fi

  mksquashfs $path $CONTAINER_OUTPUT/image.squashfs -wildcards -e ${GLOBAL_EXCLUDE_PATTERN[*]} ${EXCLUDE_PATTERN[*]}
}
