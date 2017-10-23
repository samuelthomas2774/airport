#!/bin/sh
# Sets up security for startup scripts
# 
# This adds a file on /mnt/Flash and your USB drive that will be checked before running anything
# 

FLASH="/mnt/Flash"
DEVICE="/dev/dk0"
MOUNT="/Volumes/dk0"
SCRIPT="/AirPort-startup.sh"
KEY_FILE="/AirPort-hash.key"

echo "[`date`] Running setup-security.sh"

if test ! -e $MOUNT/Shared/.com.apple.airport.sharepoint
then
	echo "[`date`] Running $DEVICE is not mounted"
	echo "[`date`] Use \`mount $DEVICE $MOUNT\` or connect to it over SMB to mount it"
	exit 1
fi

echo "[`date`] Generating 1024 bytes of data..."
KEY_DATA=`openssl rand -base64 1024`

echo "[`date`] Writing data to $MOUNT$KEY_FILE..."
echo $KEY_DATA > $MOUNT$KEY_FILE

echo "[`date`] Generating SHA512 hash of data..."
KEY_HASH=`openssl dgst -r -sha512 $MOUNT$KEY_FILE | sed -E -e "s/^.*([a-zA-Z0-9]{128}).*\$/\1/g"`
echo "[`date`] Hash is $KEY_HASH"

echo "[`date`] Writing hash to $FLASH$KEY_FILE..."
echo $KEY_HASH > $FLASH$KEY_FILE

echo "[`date`] Done!"
