#!/bin/bash
#
# Builds an lxc image from config

# Don't allow any errors
set -e

# Import library functions in lexical order
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for f in ${ROOT_DIR}/lib/*.sh; do source $f; done

main()
{
  [ $FRESH ] && fresh

  if [ $DO_INIT_ROOT ];then
    # Setup the root filesystem
    if defined pre_init_root; then pre_init_root; fi
    if defined init_root; then init_root; fi
    if defined post_init_root; then post_init_root; fi
  fi

  if [ $DO_LXC_CONFIG ];then
    # Configure LXC
    if defined pre_lxc_config; then pre_lxc_config; fi
    if defined lxc_config; then lxc_config; fi
    if defined post_lxc_config; then post_lxc_config; fi
    start_container
  fi

  if [ $DO_INSTALL_PACKAGES ];then
    # Set up any additional packages
    if defined pre_install_packages; then pre_install_packages; fi
    if defined install_packages; then install_packages; fi
    if defined post_install_packages; then post_install_packages; fi
  fi

  if [ $DO_USER_SETUP ];then
    # Set up the admin (and any other) users
    if defined pre_user_setup; then pre_user_setup; fi
    if defined user_setup; then user_setup; fi
    if defined post_user_setup; then post_user_setup; fi
  fi

  if [ $DO_CUSTOMIZE ];then
    # Allow any extra customization to happen
    if defined pre_customize; then pre_customize; fi
    if defined customize; then customize; fi
    if defined post_customize; then post_customize; fi
  fi

  if [ $DO_CLEANUP ];then
    # Cleanup the system before finalization
    if defined pre_cleanup; then pre_cleanup; fi
    if defined cleanup; then cleanup; fi
    if defined post_cleanup; then post_cleanup; fi
  fi

  if [ $DO_FINALIZE ];then
    # Finalize the system by generating a read-only image (squashfs)
    if defined pre_finalize; then pre_finalize; fi
    if defined finalize; then finalize; fi
    if defined post_finalize; then post_finalize; fi
  fi

  if [ $DO_EMBED ];then
    # Embed the system in a linux kernel
    if defined pre_embed; then pre_embed; fi
    if defined embed; then embed; fi
    if defined post_embed; then post_embed; fi
  fi

  if [ $DO_GENERATE_ISO ];then
    # Generate a bootable ISO image
    if defined pre_generate_iso; then pre_generate_iso; fi
    if defined generate_iso; then generate_iso; fi
    if defined post_generate_iso; then post_generate_iso; fi
  fi
}

main
