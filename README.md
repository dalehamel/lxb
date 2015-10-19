# What is this

Builds a simple LXC container from scratch, and outputs a squashfs container.

This squashfs container can be mounted as the base for an overlayfs.

# Container Supervisor (cvisor)

Using a container build here, the cvisor supplies a simple base system to run other system containers.

* On kernel will boot, 'toram' is used to load the cvisor image
* The cvisor image can then manage other squashfs containers
* By starting a squashfs container, the cvisor host can hand off effective control of the system to a system container

The cvisor is extremely minimal and should have the following traits:

* Nesting of cgroups (to run docker inside the system container)
* Handling of signals
 * the cvisor should reboot if the system container sends a halt
* Fetching of containers
 * The cvisor fetches and caches new system containers appropriately
* Container rollout
 * The cvisor orchestrates starting and stopping of containers in a predictable way
 * This is useful for system upgrade

# Resources

* https://help.ubuntu.com/lts/serverguide/lxc.html
* https://help.ubuntu.com/community/LiveCDCustomizationFromScratch#The_ChRoot_Environment
* http://askubuntu.com/a/306887
* https://wiki.ubuntu.com/Initramfs
* https://l3net.wordpress.com/2013/11/03/debian-virtualization-lxc-debootstrap-filesystem/
