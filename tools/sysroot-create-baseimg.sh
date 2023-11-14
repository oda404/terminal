#!/bin/bash

usage() {
    echo "$0 [options]"
    echo ""
    echo "Creates a raw disk image."
    echo ""
    echo "options:"
    echo "  -h,--help         Show this message and exit."
    echo "  -p,--path <path>  Path where to output the image."
}

cleanup()
{
	losetup --detach $LOOPDEV
	rm $IMG_PATH
	echo "Errors were encountered!"
	exit 1
}

while [[ $# -gt 0 ]]
do
	key="$1"
	case "$key" in
		"-h"|"--help")
			usage
			exit
		;;
		"-p"|"--path")
			IMG_PATH="$2"
			shift 2
		;;
		*)
			shift
		;;
	esac
done

if [ -z $IMG_PATH ]; then
	usage
	echo ""
	echo "No -p,--path specified."
	exit 1
fi

IMG_SIZE=256M

echo Creating sysroot file...
dd if=/dev/zero of=$IMG_PATH bs=$IMG_SIZE count=1 &> /dev/null

# This file is created for root and I can't be fucked to chown
chmod 666 ${IMG_PATH}

echo Setting up loopdev from file...
LOOPDEV=$(losetup --find --show --partscan $IMG_PATH) || exit 1

printf "Creating partition table & partitioning...\n"
echo "label: dos" | sfdisk $LOOPDEV > /dev/null
echo "${LOOPDEV}p1 : start= 1, size= 522240, type=83" | sfdisk $LOOPDEV > /dev/null

printf "Formatting...\n"
mkfs.fat -F32 ${LOOPDEV}p1 > /dev/null || cleanup

losetup --detach $LOOPDEV 

echo Done.
