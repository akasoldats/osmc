# (c) 2014 Sam Nazarko
# email@samnazarko.co.uk

#!/bin/bash

. ../common/funcs.sh
wd=$(pwd)
filestub="osmc-appletv-filesystem"

check_platform
verify_action

update_sources
verify_action

# Install packages needed to build filesystem for building
install_package "debootstrap"
verify_action

# Configure the target directory
ARCH="i386"
DIR="$filestub/"
RLS="jessie"

# Remove existing build
remove_existing_filesystem "{$wd}/{$DIR}"
verify_action
mkdir -p $DIR

fetch_filesystem "--arch=${ARCH} --foreign --variant=minbase ${RLS} ${DIR}"
verify_action

# Enable networking
enable_nw_chroot "${DIR}"
verify_action

# Set up sources.list
echo "deb http://ftp.debian.org/debian jessie main contrib

deb http://ftp.debian.org/debian/ jessie-updates main contrib

deb http://security.debian.org/ jessie/updates main contrib

deb http://apt.osmc.tv jessie main
" > ${DIR}/etc/apt/sources.list

# Performing chroot operation
chroot ${DIR} mount -t proc proc /proc
LOCAL_CHROOT_PKGS=""
add_apt_key "${DIR}" "http://apt.osmc.tv/apt.key"
verify_action
echo -e "Updating sources"
chroot ${DIR} apt-get update
verify_action
echo -e "Installing core packages"
chroot ${DIR} apt-get -y install --no-install-recommends $CHROOT_PKGS
verify_action
echo -e "Installing mediacenter"

# Perform filesystem cleanup
chroot ${DIR} umount /proc
cleanup_filesystem "${DIR}"

echo -e "Build successful"