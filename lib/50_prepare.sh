# Set up the actual system
prepare()
{
  # Some final updates
  cexec apt-get update
  cexec apt-get install -y linux-generic-lts-vivid

  # Only install install ramfs tools on supervisor images
  if [ $CONTAINER_SUPERVISOR ];then
    cexec apt-get install -y live-boot live-boot-initramfs-tools
  fi
}
