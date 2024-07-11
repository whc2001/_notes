# MUST REBOOT IMMEDIATELY AFTER RUNNING SUPERVISOR!!
When the supervisor is run for the first time it will find and correct configuration problems, which will put the system into unhealthy state. This will hinder all subsequent operations including restore of the backup. When the supervisor is running (in few minutes you will be able to access dashboard bla bla...) immediately reboot the OS. After rebooting it should automatically come up with a healthy state, then do the OOBE wizard.

## Lots of DNS PTR Quries
https://community.home-assistant.io/t/ha-spamming-ptr-dns-lookups/143687/79

`ha dns options --fallback=false`

## Audio Device in VM

If installed in Proxmox with `q35` machine, the default soundcard cannot be removed and will hinder the further initialization of Home Assistant audio container, which can cause actual soundcards not being detected.

Use `lspci` to find the fake sound card, remember its ID (in this example `00:1b.0`)

Edit `/etc/udev/rules.d/10-disable-qemu-soundcard.rules`:
```
ACTION=="add", KERNEL=="0000:00:1b.0", SUBSYSTEM=="pci", RUN="/bin/sh -c 'echo 1 > /sys/bus/pci/devices/0000:00:1b.0/remove'"
```
