# Container name and home
CONTAINER_NAME='cvisor'
CONTAINER_HOME='/u/lxc'
CONTAINER_OUTPUT="/u/containers/$CONTAINER_NAME"
CONTAINER_SOURCE=

# Sets up the default packages to install
PACKAGES="lxc,openssh-server,initramfs-tools" #overlayroot may not be needed

# Path to script used to embed squashfs into initramfs
EMBED_SCRIPT="/etc/initramfs-tools/hooks/embed.sh"

# Set up default flags
DEBUG=
FRESH=

reset_steps()
{
  BOOTSTRAP=
  INITIALIZE=
  PREPARE=
  CLEANUP=
  FINALIZE=
  EMBED=
}

default_steps()
{
  BOOTSTRAP=true
  INITIALIZE=true
  PREPARE=true
  CLEANUP=true
  FINALIZE=true
}

reset_steps
default_steps
