#/bin/bash

MOUNTED_SYSROOT=$(findmnt $1 -o SOURCE -n)
if [ -z "$MOUNTED_SYSROOT" ]; then
    exit 1
fi
