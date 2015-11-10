# User setup
user_setup()
{
  # Set the password for the admin user
  chroot_exec useradd -G sudo -m $ADMIN_USERNAME || true
  chroot_exec passwd $ADMIN_USERNAME << EOF 
$ADMIN_PASSWORD
$ADMIN_PASSWORD
EOF

  # Optionally, inject a public key
  if [ -n "${ADMIN_PUBKEY}"  ];then
    mkdir -p "${CONTAINER_HOME}/${CONTAINER_NAME}/rootfs/home/${ADMIN_USERNAME}/.ssh"
    echo "${ADMIN_PUBKEY}" > "${CONTAINER_HOME}/${CONTAINER_NAME}/rootfs/home/${ADMIN_USERNAME}/.ssh/authorized_keys"
    chroot_exec chown -R ${ADMIN_USERNAME} /home/${ADMIN_USERNAME}/.ssh
    chroot_exec chmod 600 /home/${ADMIN_USERNAME}/.ssh/authorized_keys
  fi
}
