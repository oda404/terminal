#!/bin/bash

# Copyright 2023 Alexandru Olaru.
# Distributed under the MIT license.

help() {
	echo "$0 [options]"
	echo
	echo "Mount the kernel's sysroot on the host machine."
	echo 
	echo "options:"
	echo "  -h, --help      Print this message and exit."
	echo "  --sysroot-img   Path to the sysroot image."
	echo "  --mountpoint    Where on the host machine to mount the image."
	echo "  --uid           User id as which to mount the sysroot."
	echo "  --gid           Group id as which to mount the sysroot."
}

cleanup()
{
	losetup --detach $LOOPDEV
	exit 1
}

while [[ $# -gt 0 ]]
do
	key="$1"
	case "$key" in
		"--sysroot-img")
			SYSROOT_IMG="$2"
			shift 2
		;;
		"--mountpoint")
			MOUNTPOINT="$2"
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


if [ -z "$SYSROOT_IMG" ] || [ -z "$MOUNTPOINT" ]; then
	help
	echo 
	echo "Bad usage"
	exit 1
fi

if [ -z "$INIT_UID" ]; then
	INIT_UID=$UID
fi

if [ -z "$INIT_GID" ]; then
	INIT_GID=$UID # Might not always be the case ?
fi

mkdir -p $MOUNTPOINT || exit 1

LOOPDEV=$(losetup --find --show --partscan $SYSROOT_IMG)
if [ $? != 0 ]; then
	exit 1
fi

mount -o uid=$INIT_UID,gid=$INIT_GID ${LOOPDEV}p1 $MOUNTPOINT || cleanup

echo $LOOPDEV
