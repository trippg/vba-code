# Haven Team Mesh — Build Plan

One full Haven node as the hub, plus small Heltec HaLow nodes for each group
that splits off. Every phone joins the Wi-Fi of whichever node is closest, and
all nodes link to each other over Wi-Fi HaLow (915 MHz), so the whole team is on
one network.

Based on the open-source Haven project by Parallel:
https://github.com/buildwithparallel/haven-manet-ip-mesh-radio

## Layout

```
            Internet (optional: Starlink, router, hotel Ethernet)
                 │
        ┌────────┴────────┐
        │   HAVEN (hub)   │  Pi + HaLow + battery + our remixed case
        │   Wi-Fi: phones │
        └───┬─────────┬───┘
     HaLow  │         │  HaLow  (km range, nodes relay for each other)
     ┌──────┴──┐   ┌──┴──────┐   ┌─────────┐
     │ Heltec 1│───│ Heltec 2│───│ Heltec 3│
     │ Wi-Fi:  │   │ Wi-Fi:  │   │ Wi-Fi:  │
     │ phones  │   │ phones  │   │ phones  │
     └─────────┘   └─────────┘   └─────────┘
```

## Bill of materials

### Hub — 1× full Haven (Haven 1 platform, recommended by Parallel)

| Part | Notes |
|---|---|
| Raspberry Pi 4 Model B (or CM4) | |
| Seeed WM-WM6108 HaLow HAT (Morse Micro MM6108, SPI) | Add 1 mm to case standoffs so the HAT seats fully on the GPIO header |
| Panda Wireless RT5370 USB Wi-Fi adapter | 2.4 GHz Wi-Fi for phones |
| Waveshare 21700 UPS HAT, 2-cell + 2× 21700 cells | ~10,000 mAh |
| 900–915 MHz SMA antenna | Base diameter 14 mm or less to fit the case |
| microSD card | OpenMANET firmware |
| Haven case (our remix of the Printables original) | Print in PA6-CF / NylonX |

Typical hub hardware cost per Parallel: ~$208–$450.

### Small nodes — 3× Heltec (one per group; adjust count to team size)

| Part | Qty | Notes |
|---|---|---|
| Heltec Wi-Fi HaLow Dongle **V2** (HT-HD01 V2) | 3 | Must be V2 — OpenMANET does not support V1. Confirm the 27 dBm variant when ordering. ~$70–$140 each |
| 900–915 MHz SMA antenna | 3 | Not included with the dongle |
| USB-C power bank | 3 | Dongle has no battery. Power draw not published — test runtime |
| Small case (dongle + power bank + antenna) | 3 | To design alongside the hub case |

### Each team member

- Phone with **Sideband** (encrypted messaging + location) and/or **ATAK/CivTAK** (maps)

## Setup

### 1. Hub (Gate)

1. Flash OpenMANET onto the microSD (Raspberry Pi Imager).
2. Connect by Ethernet, open `http://10.41.254.1`, user `root`, no password.
3. Set hostname `green`, password, country US → Apply.
4. Wizards → 802.11s Mesh → **Mesh Gate** → Ethernet upstream.
5. Plug into a router, SSH in, run the Haven gate script:
   ```
   wget -O /tmp/setup.sh "https://raw.githubusercontent.com/buildwithparallel/haven-manet-ip-mesh-radio/main/scripts/node-setup/setup-haven-gate.sh?$(date +%s)" && sh /tmp/setup.sh
   ```
6. Wait for reboot (~60 s), then confirm a phone on the `green` Wi-Fi works.

### 2. Each Heltec node

1. Flash OpenMANET onto the Heltec V2 (the OpenMANET image includes its calibration file).
2. Connect to its Wi-Fi, SSH to `root@10.42.0.1` (default password `heltec.org`).
3. Edit the top of `configure-heltec.sh` with a unique name and IP per node:

   | Node | `HOSTNAME` | `MESH_IP` |
   |---|---|---|
   | Heltec 1 | `heltec-1` | `10.41.0.11` |
   | Heltec 2 | `heltec-2` | `10.41.0.12` |
   | Heltec 3 | `heltec-3` | `10.41.0.13` |

   `GATEWAY_IP` = the hub's mesh IP (`uci get network.ahwlan.ipaddr` on the hub).
4. Paste and run the script, then `reboot`.
5. Channel, channel width, mesh ID and mesh key must match the hub on every node.

### 3. Before field use

- Change every root password and Wi-Fi password from the defaults.
- Pick a channel width for the job: 1 MHz for max range (~3 Mbps), 2 MHz balanced, 8 MHz for speed at short range. Same width on all nodes.
- Range test with `scripts/tools/halow_range_test.py` from the Haven repo.
- Run a power-bank runtime test on one Heltec.

## Open items

- [ ] Pick antenna model (hub + 3 Heltecs)
- [ ] Pick power bank model / capacity for Heltecs
- [ ] Design small Heltec case
- [ ] Finalize hub case remix (standoff +1 mm, antenna port ≤14 mm)
- [ ] Decide number of Heltec nodes for team size
- [ ] Optional: buy the Parallel Haven Guide ($97) for the official BOM and wiring

## References

- Haven repo: https://github.com/buildwithparallel/haven-manet-ip-mesh-radio
- Haven case (Printables): https://www.printables.com/model/1468595-haven-case-for-raspberry-pi-based-manet-by-paralle
- OpenMANET Heltec notes: https://openmanet.github.io/docs/hardware/heltec
- OpenMANET firmware: https://openmanet.net/
