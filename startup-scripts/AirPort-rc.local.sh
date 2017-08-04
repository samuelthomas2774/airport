#!/bin/sh
# Save this to /mnt/Flash/rc.local
# This file first mounts /dev/dk0 in /Volumes/dk0, then executes /Volumes/dk0/AirPort-startup.sh

# ... we might have to mount the disk first
if test ! -d /Volumes/dk0 -a -e /dev/dk0
then
	AUTO_UNMOUNT=true
	mount /dev/dk0 /Volumes/dk0
else
	AUTO_UNMOUNT=false
fi

if [ -x /Volumes/dk0/AirPort-startup.sh ]
then
	/Volumes/dk0/AirPort-startup.sh 2> /dev/null
fi

# Unmount the disk - before diskd tries to mount it again
# AirPort-startup.sh should copy any files it needs to somewhere in the main partition
if [ "$AUTO_UNMOUNT" = true ]
then
	umount /dev/dk0
fi

exit 0
