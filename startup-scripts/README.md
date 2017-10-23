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

### Security

This allows anything to be run on an AirPort device at startup. It is able to verify the source using a hash stored in `/mnt/Flash` and on the USB drive. To generate the files for this, run `setup-security.sh` on the AirPort base station.

```sh
airport-extreme# cd /Volumes/dk0/airport
airport-extreme# startup-scripts/setup-security.sh
[Mon Oct 23 16:35:50 BST 2017] Running setup-security.sh
[Mon Oct 23 16:35:50 BST 2017] Generating 1024 bytes of data...
WARNING: can't open config file: /etc/openssl/openssl.cnf
[Mon Oct 23 16:35:50 BST 2017] Writing data to /Volumes/dk0/AirPort-hash.key...
[Mon Oct 23 16:35:51 BST 2017] Generating SHA512 hash of data...
WARNING: can't open config file: /etc/openssl/openssl.cnf
[Mon Oct 23 16:35:51 BST 2017] Hash is b3697262ed6d1f844167216af791fff5b2332b05b929c7404593de0a0051fff36a14c31f217e0408226b46900cfa7c914605f8dc4e6d14c44b57c771632cf80c
[Mon Oct 23 16:35:51 BST 2017] Writing hash to /mnt/Flash/AirPort-hash.key...
[Mon Oct 23 16:35:51 BST 2017] Done!

```

This will generate 1024 bytes of data and write it to `/AirPort-hash.key` on the USB drive, and write the SHA512 hash of the data to `/AirPort-hash.key` on the AirPort base station's persistent partition.

The hash will automatically be checked against the data on the USB drive if it exists. If it fails nothing will be run.
