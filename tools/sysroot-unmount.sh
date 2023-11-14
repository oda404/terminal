#!/bin/bash

# Copyright 2023 Alexandru Olaru.
# Distributed under the MIT license.

help() {
	echo "$0 [options]"
	echo
	echo "Unmount the kernel's sysroot from the host machine."
	echo 
	echo "options:"
	echo "  -h, --help   Print this message and exit."
	echo "  --sysroot    The system root mount point."
}

while [[ $# -gt 0 ]]
do
	key="$1"
	case "$key" in
		"--sysroot")
			SYSROOT="$2"
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

if [ -z "$SYSROOT" ]; then
	help
	echo 
	echo "Bad usage"
	exit 1
fi

LOOPDEV=$(findmnt $SYSROOT -o SOURCE -n)
if [ -z "$LOOPDEV" ]; then
	exit 0
fi

umount $SYSROOT
losetup --detach $(echo $LOOPDEV | rev | cut -c 3- | rev)
