#!/bin/sh
# Runs inject.sh every minute to catch changes to pf.conf
# This requires the whole repository (or at least pf/inject.sh and pf/sed.txt) to have been copied to /airport
# 
# Example:
#     cp ./airport /airport
#     /airport/pf/injectd.sh > /AirPort-pf-injectd.sh.log 2>&1 &
# 

while true
do
	echo "[`date`] Running pf/inject.sh..."
	/airport/pf/inject.sh /airport/pf/sed.txt
	sleep 5
done
