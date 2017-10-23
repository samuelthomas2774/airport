#!/bin/sh
# Save this to /mnt/Flash/AirPort-rc.local.sh
# This file first mounts /dev/dk0 in /Volumes/dk0, then executes /Volumes/dk0/AirPort-startup.sh

DEVICE="/dev/dk0"
MOUNT="/Volumes/dk0"
SCRIPT="/AirPort-startup.sh"
LOG="/AirPort-rc.local.sh.log"
DEBUG_INFO="/AirPort-rc.local.sh.debug.log"

echo "[`date`] Running AirPort-rc.local.sh" >> $LOG
echo "[`date`] Running AirPort-rc.local.sh" >> $DEBUG_INFO

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
if [ $AUTO_UNMOUNT = true ]
then
	cd /
	
	echo "[`date`] Printing ps -A to $DEBUG_INFO..." >> $LOG
	printf "\n[`date`] Printing ps -A to debug info...\n" >> $DEBUG_INFO
	ps -A >> $DEBUG_INFO
	
	# Kill diskd (and later restart it) incase the disk being mouted has already stopped diskd from working
	echo "[`date`] Killing diskd..." >> $LOG
	pkill -KILL diskd >> $LOG 2>&1
	
	echo "[`date`] Unmounting $DEVICE" >> $LOG
	# Forcibly unmount - diskd really doesn't like this to be here on startup
	umount -f $DEVICE >> $LOG 2>&1
	
	# Seems to work...
	echo "[`date`] Killing diskd..." >> $LOG
	pkill -KILL diskd >> $LOG 2>&1
	
	sleep 5
	
	# Restart diskd
	echo "[`date`] Starting diskd..." >> $LOG
	/sbin/diskd -i  -d > /var/log/diskd.log 2>&1 &
	
	echo "[`date`] Printing ps -A to $DEBUG_INFO..." >> $LOG
	printf "\n[`date`] Printing ps -A to debug info...\n" >> $DEBUG_INFO
	ps -A >> $DEBUG_INFO
fi

echo "[`date`] Done!" >> $LOG

exit 0
