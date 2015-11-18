# Anything needed to set up the actual system
install_packages()
{
  # Perform an update of apt sources
  cexec apt-get update
  cexec apt-get -f install -y
  cexec apt-get upgrade -y

  # Install extra packages that couldn't be done during debootstrap
  # For instance, anything not on a component of the primary mirror
  if [ -n "$EXTRA_PACKAGES" ];then
    cexec /usr/bin/env DEBIAN_FRONTEND=noninteractive apt-get install -y $EXTRA_PACKAGES
  fi
}
