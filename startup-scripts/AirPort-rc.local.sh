#!/bin/sh
# Save this to /mnt/Flash/rc.local
# This file first mounts /dev/dk0 in /Volumes/dk0, then executes /Volumes/dk0/AirPort-startup.sh

DEVICE="/dev/dk0"
MOUNT="/Volumes/dk0"
SCRIPT="/AirPort-startup.sh"
LOG="/AirPort-rc.local.sh.log"

echo "[`date`] Running AirPort-rc.local.sh" > $LOG

# ... we might have to mount the disk first
# We don't actually have any way of checking that though
# Try checking if files diskd creates on mount exist
if test ! -e $MOUNT/Shared/.com.apple.airport.sharepoint -a -e $DEVICE
then
	echo "[`date`] $DEVICE exists and is not mounted" >> $LOG
	AUTO_UNMOUNT=true
	mkdir -p $MOUNT
	mount $DEVICE $MOUNT
else
	echo "[`date`] $DEVICE does not exist or is already mounted" >> $LOG
	AUTO_UNMOUNT=false
fi

if [ -x $MOUNT$SCRIPT ]
then
	echo "[`date`] $MOUNT$SCRIPT exists and is executable" >> $LOG
	echo "[`date`] Running it now..." >> $LOG
	cd $MOUNT
	$MOUNT$SCRIPT >> $LOG 2>&1
	echo "[`date`] Done!" >> $LOG
fi

# Unmount the disk - before diskd tries to mount it again
# AirPort-startup.sh should copy any files it needs to somewhere in the main partition
if [ "$AUTO_UNMOUNT" = true ]
then
	echo "[`date`] Unmounting $DEVICE" >> $LOG
	# Forcibly unmount - diskd really doesn't like this to be here on startup
	umount -f $DEVICE
fi

exit 0
