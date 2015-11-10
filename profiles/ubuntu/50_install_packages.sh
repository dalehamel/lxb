# Anything needed to set up the actual system
install_packages()
{
  # Perform an update of apt sources
  cexec apt-get update

  # Install extra packages that couldn't be done during debootstrap
  # For instance, anything not on a component of the primary mirror
  if [ -n "$EXTRA_PACKAGES" ];then
    cexec apt-get install --no-install-recommends -y $EXTRA_PACKAGES
  fi
}
