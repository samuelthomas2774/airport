#!/bin/sh
# Actually, save this one to /mnt/Flash/rc.local
# This will run AirPort-run-on-ifup.sh which will then run AirPort-rc.local.sh when the system is up

SCRIPT="/mnt/Flash/AirPort-rc.local.sh"
RUNONIFUP_SH="/mnt/Flash/AirPort-run-on-ifup.sh"
LOG="/AirPort-rc.local.sh.log"
DEBUG_INFO="/AirPort-rc.local.sh.debug.log"

echo "[`date`] Running AirPort-run.sh" > $LOG
echo "[`date`] Running AirPort-run.sh" > $DEBUG_INFO

echo "[`date`] Printing df to $DEBUG_INFO..." >> $LOG
printf "\n[`date`] Printing df to debug info...\n" >> $DEBUG_INFO
df >> $DEBUG_INFO

echo "[`date`] Printing ps -A to $DEBUG_INFO..." >> $LOG
printf "\n[`date`] Printing ps -A to debug info...\n" >> $DEBUG_INFO
ps -A >> $DEBUG_INFO

echo "[`date`] Printing \$PATH to $DEBUG_INFO..." >> $LOG
printf "\n[`date`] Printing \$PATH to debug info...\n" >> $DEBUG_INFO
echo $PATH >> $DEBUG_INFO

echo "[`date`] Starting $RUNONIFUP_SH..." >> $LOG
$RUNONIFUP_SH bridge0 $SCRIPT >> $LOG
echo "[`date`] Started $RUNONIFUP_SH, pid $!" >> $LOG

echo "[`date`] Finished running AirPort-run.sh" >> $LOG
echo "[`date`] Finished running AirPort-run.sh" >> $DEBUG_INFO

exit 0
