#!/bin/sh
# Run this to add anchors to /etc/pf.conf to allow for easier manipulation of pf
# 
# This will add anchors before and after predefined sections:
# nat-anchor "AirPort-nat-before", before the line "no nat inet from ! <priv4>"
# rdr-anchor "AirPort-nat-before", just after that
# nat-anchor "AirPort-nat-after", before the line "block drop in quick from 224.0.0.0/3"
# rdr-anchor "AirPort-nat-after", just after that
# anchor "AirPort-filter-before", before the line "block drop in quick from 224.0.0.0/3"
# anchor "AirPort-filter-after", before the line "anchor \"natpmp\""
# anchor "AirPort-natpmp-after", after the line "anchor \"ftp-proxy/*\""
# 
# These lines exist in my configuration (connecting using PPPoE, guest network disabled)
# Not tested on other configurations, but likely will not work if NAT is not enabled
# 
# And then load each anchor from different files:
# load anchor "AirPort-nat-before" from "/AirPort-pf/nat-before.conf"
# load anchor "AirPort-nat-after" from "/AirPort-pf/nat-after.conf"
# load anchor "AirPort-filter-before" from "/AirPort-pf/filter-before.conf"
# load anchor "AirPort-filter-after" from "/AirPort-pf/filter-after.conf"
# load anchor "AirPort-natpmp-after" from "/AirPort-pf/natpmp-after.conf"
# 

SED_TXT_FILE="$1"
DIR="/AirPort-pf"
LOG="/AirPort-pf-inject.sh.log"

echo "[`date`] Running pf/inject.sh" > $LOG

# Check $SED_TXT_FILE
if [ -f "$SED_TXT_FILE" ]
then
	echo "Using \$SED_TXT_FILE $SED_TXT_FILE" >> $LOG
else
	echo "\$SED_TXT_FILE [$SED_TXT_FILE] does not exist" >> $LOG
	exit 1
fi

cp /etc/pf.conf $DIR/original-pf.conf
echo "Original pf.conf file at $DIR/original-pf.conf" >> $LOG

sed -E -f $SED_TXT_FILE /etc/pf.conf > $DIR/pf.conf 2>> $LOG
echo "Updated pf.conf saved as $DIR/pf.conf" >> $LOG

# Reload pf.conf
echo "Reloading pf.conf from $DIR/pf.conf" >> $LOG
pfctl -f $DIR/pf.conf >> $LOG 2>&1

# Load /AirPort-pf/nat-before.conf as anchor "AirPort-nat-before" if it exists
if [ -f $DIR/nat-before.conf ]
then
	echo "Reloading AirPort-nat-before from $DIR/nat-before.conf" >> $LOG
	pfctl -a AirPort-nat-before -f $DIR/nat-before.conf >> $LOG 2>&1
fi

# Load /AirPort-pf/nat-after.conf as anchor "AirPort-nat-after" if it exists
if [ -f $DIR/nat-after.conf ]
then
	echo "Reloading AirPort-nat-after from $DIR/nat-after.conf" >> $LOG
	pfctl -a AirPort-nat-after -f $DIR/nat-after.conf >> $LOG 2>&1
fi

# Load /AirPort-pf/filter-before.conf as anchor "AirPort-filter-before" if it exists
if [ -f $DIR/filter-before.conf ]
then
	echo "Reloading AirPort-filter-before from $DIR/filter-before.conf" >> $LOG
	pfctl -a AirPort-filter-before -f $DIR/filter-before.conf >> $LOG 2>&1
fi

# Load /AirPort-pf/filter-after.conf as anchor "AirPort-filter-after" if it exists
if [ -f $DIR/filter-after.conf ]
then
	echo "Reloading AirPort-filter-after from $DIR/filter-after.conf" >> $LOG
	pfctl -a AirPort-filter-after -f $DIR/filter-after.conf >> $LOG 2>&1
fi

# Load /AirPort-pf/natpmp-after.conf as anchor "AirPort-natpmp-after" if it exists
if [ -f $DIR/natpmp-after.conf ]
then
	echo "Reloading AirPort-anchor-after from $DIR/anchor-after.conf" >> $LOG
	pfctl -a AirPort-natpmp-after -f $DIR/natpmp-after.conf >> $LOG 2>&1
fi

echo "[`date`] Output by airport/pf/inject.sh" >> $LOG
