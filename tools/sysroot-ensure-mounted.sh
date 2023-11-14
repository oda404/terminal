#!/bin/bash

# Copyright 2023 Alexandru Olaru.
# Distributed under the MIT license.

help() {
	echo "$0 [options]"
	echo
	echo "Ensure a sysroot image is mounted on the sysroot mount point."
	echo 
	echo "options:"
	echo "  -h, --help         Print this message and exit."
	echo "  --sysroot-image    Path to the sysroot image."
	echo "  --sysroot          Sysroot directory to copy to --image-path."
	echo "  --uid              UID to mount the sysroot as."
	echo "  --gid              GID to mount the sysroot as."
}

while [[ $# -gt 0 ]]
do
	key="$1"
	case "$key" in
		"--sysroot")
			SYSROOT="$2"
			shift 2
		;;
		"--sysroot-image")
			SYSROOT_IMAGE="$2"
			shift 2
		;;
		"--uid")
			INIT_UID="$2"
			shift 2
		;;
		"--gid")
			INIT_GID="$2"
			shift 2
		;;
		"-h"|"--help")
			help
			exit 1
		;;
		*)
			shift
		;;
	esac
done

if [ -z "$SYSROOT" ] || [ -z "$SYSROOT_IMAGE" ]; then
    help
    echo "Wrong usage"
    exit 1
fi

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! [ -f $SYSROOT_IMAGE ]; then
    ${SCRIPTDIR}/sysroot-create-baseimg.sh --path $SYSROOT_IMAGE || exit 1
fi

MOUNTED_SYSROOT=$(findmnt $SYSROOT -o SOURCE -n)
if [ -z "$MOUNTED_SYSROOT" ]; then
    ${SCRIPTDIR}/sysroot-mount.sh --sysroot-img $SYSROOT_IMAGE --mountpoint $SYSROOT --uid $INIT_UID --gid $INIT_GID > /dev/null || exit 1
fi
