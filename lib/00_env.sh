# Container name and home
CONTAINER_HOME='/u/lxc'
CONTAINER_NAME=
CONTAINER_OUTPUT=
CONTAINER_SOURCE=

# Global section
# Anything here has a corresponding variable (without the GLOBAL_)
# that can be appended from inside the config file.

# Sets up the default packages to install
GLOBAL_PACKAGES=""

# Packages to blacklist during debootstrap
GLOBAL_BLACKLIST_PACKAGES="grub-pc-bin"

# Patterns to be excluded from final image
GLOBAL_EXCLUDE_PATTERN=('boot/*' 'usr/src' 'var/lib/apt/lists/archive*')

# Path to script used to embed squashfs into initramfs
EMBED_SCRIPT="/etc/initramfs-tools/hooks/embed.sh"

# The distro to use for debootstrap
DISTRO=trusty

# The mirror to use for debootsrap
MIRROR=http://archive.ubuntu.com/ubuntu/

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
