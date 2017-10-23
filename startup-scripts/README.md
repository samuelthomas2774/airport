Startup scripts on AirPort base stations
---

See the [wiki page](https://github.com/samuelthomas2774/airport/wiki/Startup-scripts) for more information.

### Installation

Copy `AirPort-run.sh` as `rc.local`, `AirPort-rc.local.sh` and `AirPort-run-on-ifup.sh` to `/mnt/Flash`.

```sh
cp /Volumes/dk0/Users/S.Elliott/airport/startup-scripts/AirPort-run.sh /mnt/Flash/rc.local
cp /Volumes/dk0/Users/S.Elliott/airport/startup-scripts/AirPort-rc.local.sh /mnt/Flash/AirPort-rc.local.sh
cp /Volumes/dk0/Users/S.Elliott/airport/startup-scripts/AirPort-run-on-ifup.sh /mnt/Flash/AirPort-run-on-ifup.sh

```

Delete those files to return your AirPort base station to it's previous state.

```sh
rm /mnt/Flash/rc.local
rm /mnt/Flash/AirPort-rc.local.sh
rm /mnt/Flash/AirPort-run-on-ifup.sh
reboot

```

### Usage

Once the system has started and is ready (the system may not have obtained a DHCP lease on it's WAN interface / connected to a PPPoE server yet though), it will run `/AirPort-startup.sh` on the USB drive connected to the AirPort base station.
