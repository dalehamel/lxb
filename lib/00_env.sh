# Container name and home
CONTAINER_HOME='/u/lxc'
CONTAINER_NAME=
CONTAINER_OUTPUT=
CONTAINER_SOURCE=

# Global section
# Anything here has a corresponding variable (without the GLOBAL_)
# that can be appended from inside the config file.

# Sets up the default packages to install
GLOBAL_PACKAGES="sudo"

# Packages to blacklist during debootstrap
#GLOBAL_BLACKLIST_PACKAGES="grub-pc-bin"

# Patterns to be excluded from final image
GLOBAL_EXCLUDE_PATTERN=('usr/src' 'var/lib/apt/lists/archive*')

# Path to script used to embed squashfs into initramfs
EMBED_SCRIPT="/etc/initramfs-tools/hooks/embed.sh"

# The distro to use for debootstrap
DISTRO=trusty

# The mirror to use for debootsrap
MIRROR=http://archive.ubuntu.com/ubuntu/

# Typically don't want to install these
BLACKLIST_PACKAGES="wpasupplicant"

# Admin settings (not secure)
ADMIN_USERNAME=console
ADMIN_PASSWORD=cvisor

ADMIN_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCd9MR4lTtEreJqyXWjVRxxMzYMUxYTLr0PMDkY52BgiBVHL+JY8Pbx7hcEaSkd9wMlun6Jverq3QYXUk+1FOOBJwC/ATZloCav0sqn9/37QrMvBPcwHgH054abKZJ0ctkpBTUa7AS+IRtco30i7J7Irzr6jbRvZ2BO6Nh1TlhGBQ0y5IOEMBhWMq9sUXBNmsNxDSGaabEX83Dkgk4pkTtr4Sk0oUpWWI94E3zttYAP6e7gRhiOn6LeYiDfTvIRkN9c/scErs1W3Pa6WY0EWLR7TeVtSWVEo5QIYbJbXRJTOCWyoMc8u5f9c82kIPG+4Ufe9wLUd7t2kVUDh6v89Ord daleha@Zenframe"

# Extra kernel arguments
KERNEL_ARGS=""

# No-op for customization phaze if not needed
customize()
{
  echo "Customization noop"
}
