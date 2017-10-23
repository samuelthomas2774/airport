Modifying the pf ruleset
---

Using some tools on the AirPort base station it is possible to edit the configuration file for pf.

### Installation

Just run `pf/inject.sh` in your startup scripts.

```sh
./airport/pf/inject.sh ./airport/pf/sed.txt

```

### Usage

`pf/inject.sh` will update pf.conf with several anchors:

```
nat-anchor "AirPort-nat-before", before the line "no nat inet from ! <priv4>"
rdr-anchor "AirPort-nat-before", just after that
nat-anchor "AirPort-nat-after", before the line "block drop in quick from 224.0.0.0/3"
rdr-anchor "AirPort-nat-after", just after that
anchor "AirPort-filter-before", before the line "block drop in quick from 224.0.0.0/3"
anchor "AirPort-filter-after", before the line "anchor \"natpmp\""
anchor "AirPort-natpmp-after", after the line "anchor \"ftp-proxy/*\""

```

They will automatically be loaded from `/AirPort-pf` if they exist. Most filter rules should go in `/AirPort-pf/filter-after.conf`, and most NAT / RDR rules should go in `/AirPort-pf/nat-after.conf`.

The file `pf/injectd.sh` runs `pf/inject.sh` every minute, and should be used instead of `pf/inject.sh` until I can figure out why my pf ruleset sometimes disappears.

```sh
/airport/pf/injectd.sh > /AirPort-pf-injectd.sh.log 2>&1 &

```
