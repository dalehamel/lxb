embed(){
  tmp_image="$CONTAINER_HOME/$CONTAINER_NAME/rootfs/tmp/image.squashfs"
  cp "$CONTAINER_OUTPUT/image.squashfs"  $tmp_image

  # Tell initramfs-tools to embed our system image into the initramfs
  cat > "$CONTAINER_HOME/$CONTAINER_NAME/rootfs/$EMBED_SCRIPT" << EOF
#!/bin/sh
PREREQ=""
prereqs()
{
     echo "\$PREREQ"
}

case \$1 in
prereqs)
     prereqs
     exit 0
     ;;
esac

. /usr/share/initramfs-tools/hook-functions
# /live/medium/live tricks the system into not having to mount
# an external device to find the squashfs
mkdir -p \$DESTDIR/live/
mv /tmp/image.squashfs \$DESTDIR/live/

# http://manpages.ubuntu.com/manpages/trusty/man7/live-boot.7.html
# Set up the live system
cat > \$DESTDIR/boot.conf << EOD
console=ttyS1,115200 # set up the IPMI serial console
ip=frommedia # use the system's ip address strategy (probably DHCP)
toram # load entire system to ram
union=overlayfs  # Allow a r/w system using overlayfs
                 # Note overlayfs isn't documented, but appears to be supported
EOD
EOF

  # Inject our hook into the main script... unfortunately this seems to be necessary.
  patch_dir="$( dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ))/patches"
  patch  -B  /tmp/gargbage -r - --forward "$CONTAINER_HOME/$CONTAINER_NAME/rootfs/lib/live/boot/9990-main.sh" < $patch_dir/fuck || true

  # Prepare the desired initrd and kernel with squashfs embedded
  cexec chmod +x $EMBED_SCRIPT
  cexec update-initramfs -u

  # Extract our payload
  bootdir="${CONTAINER_OUTPUT}/boot"
  mkdir -p $bootdir
  cp "$CONTAINER_HOME/$CONTAINER_NAME/rootfs/boot/initrd"* $bootdir
  cp "$CONTAINER_HOME/$CONTAINER_NAME/rootfs/boot/vmlinuz"* $bootdir

  # Clean up
  rm -f $tmp_image
  cexec rm $EMBED_SCRIPT
  cexec update-initramfs -u
}
