# Sets up the default packages to install
GLOBAL_PACKAGES="sudo"

# Packages to blacklist during debootstrap
#GLOBAL_BLACKLIST_PACKAGES="grub-pc-bin"

# Patterns to be excluded from final image
GLOBAL_EXCLUDE_PATTERN=('usr/src' 'var/lib/apt/lists/archive*')

# Path to script used to embed squashfs into initramfs
EMBED_SCRIPT="/etc/initramfs-tools/hooks/embed.sh"

# The mirror to use for debootsrap
MIRROR=http://archive.ubuntu.com/ubuntu/

# Typically don't want to install these
BLACKLIST_PACKAGES="wpasupplicant"
