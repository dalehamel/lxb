finalize()
{
  mkdir -p $CONTAINER_OUTPUT
  mksquashfs "$CONTAINER_HOME/$CONTAINER_NAME" $CONTAINER_OUTPUT/image.squashfs #-comp xz
}
