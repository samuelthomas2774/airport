#!/bin/sh

# Run this as ./AirPort-run-on-ifup.sh {path-to-script}
# As the USB drive may have been unmounted by the time bridge0 comes up, you must copy the script to the root partition
# Example: cp /Volumes/dk0/AirPort-setroutes.sh /AirPort-setroutes.sh
#     ...: /Volumes/dk0/AirPort-run-on-ifup.sh /AirPort-setroutes.sh
# The script will get the first IP address as it's first argument

#INTERFACE="bridge0"
INTERFACE="$1"
DIRECTORY="/AirPort-run-on-ifup"
RUN="$2"
export CD="/"

mkdir -p $DIRECTORY
echo "#!/bin/sh" > $DIRECTORY/$$-up.sh
echo "export CD=\"$CD\"" >> $DIRECTORY/$$-up.sh

echo "if [ \"\$5\" != \"\" ]" >> $DIRECTORY/$$-up.sh
echo "then" >> $DIRECTORY/$$-up.sh
echo "    IP_VERSION=4" >> $DIRECTORY/$$-up.sh
echo "else" >> $DIRECTORY/$$-up.sh
echo "    IP_VERSION=6" >> $DIRECTORY/$$-up.sh
echo "fi" >> $DIRECTORY/$$-up.sh

if [ "$3" = "inet6" ]
then
	echo "if [ \"\$IP_VERSION\" = \"4\" ]" >> $DIRECTORY/$$-up.sh
	echo "then" >> $DIRECTORY/$$-up.sh
	echo "    exit" >> $DIRECTORY/$$-up.sh
	echo "fi" >> $DIRECTORY/$$-up.sh
elif [ "$3" = "inet4" ]
then
	echo "if [ \"\$IP_VERSION\" = \"6\" ]" >> $DIRECTORY/$$-up.sh
	echo "then" >> $DIRECTORY/$$-up.sh
	echo "    exit" >> $DIRECTORY/$$-up.sh
	echo "fi" >> $DIRECTORY/$$-up.sh
elif [ "$3" = "inet46" ]
then
	echo "if [ \"\$IP_VERSION\" = \"6\" && ! -f \"$DIRECTORY/$$-inet4\" ]" >> $DIRECTORY/$$-up.sh
	echo "then" >> $DIRECTORY/$$-up.sh
	echo "    echo \"\" >> $DIRECTORY/$$-inet6" >> $DIRECTORY/$$-up.sh
	echo "    exit" >> $DIRECTORY/$$-up.sh
	echo "elif [ \"\$IP_VERSION\" = \"4\" && ! -f \"$DIRECTORY/$$-inet6\" ]" >> $DIRECTORY/$$-up.sh
	echo "then" >> $DIRECTORY/$$-up.sh
	echo "    echo \"\" >> $DIRECTORY/$$-inet4" >> $DIRECTORY/$$-up.sh
	echo "    exit" >> $DIRECTORY/$$-up.sh
	echo "fi" >> $DIRECTORY/$$-up.sh
fi

echo "echo \"#!/bin/sh\" > $DIRECTORY/$$-up.sh" >> $DIRECTORY/$$-up.sh
echo "echo \"kill \\\`cat $DIRECTORY/$$-ifwatchd.pid\\\`\" >> $DIRECTORY/$$-up.sh" >> $DIRECTORY/$$-up.sh
echo "kill \`cat $DIRECTORY/$$-ifwatchd.pid\`" >> $DIRECTORY/$$-up.sh
echo "$RUN \$4 inet\$IP_VERSION>> $DIRECTORY/$$.log 2>&1" >> $DIRECTORY/$$-up.sh
chmod +x $DIRECTORY/$$-up.sh

/usr/sbin/ifwatchd -v -u $DIRECTORY/$$-up.sh $INTERFACE > $DIRECTORY/$$-ifwatchd.log 2>&1 &
echo $! > $DIRECTORY/$$-ifwatchd.pid
