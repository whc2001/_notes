# EXT4 Filesystem Become RO
> https://forum.openwrt.org/t/why-is-openwrts-dev-root-turn-to-read-only-mode/28631/4?u=whc2001
> https://macgeeker.com/openwrt/openwrt-readonly/

# Change eth device name according to MAC address
> https://openwrt.org/docs/guide-user/base-system/hotplug#rename_interfaces_by_mac_address

Run the script in `/etc/rc.local`

```bash
CONF_FILE="/root/eth_device_names.tsv"

devices="$(ls /sys/class/net/*/device/uevent | awk -F '/' '{print $5}')"
for deviceName in ${devices}; do
    hasConf=0
    deviceMAC="$(cat /sys/class/net/"${deviceName}"/address)"
    ip link set "${deviceName}" down
    while IFS= read -r line; do
        confMAC=$(echo -n "$line" | cut -f 1)
        confName=$(echo -n "$line" | cut -f 2)
        if [ -n "${confMAC}" -a -n "${confName}" ] && [ "${deviceMAC}" == "${confMAC}" ]; then
            ip link set "${deviceName}" name "${confName}"
            hasConf=1
            break
        fi
    done < $CONF_FILE
    if [ $hasConf -eq 0 ]; then
        # If not specified in config file, default to last 4 digit of MAC
        defName="eth$(echo -n $deviceMAC | sed "s/://g" | tail -c 4 | tr "a-f" "A-F")"
        ip link set "${deviceName}" name "${defName}"
    fi
done
/etc/init.d/network reload
```

Config file (TSV):
```
XX:XX:XX:XX:XX:XX	ethLAN1
XX:XX:XX:XX:XX:XX	ethLAN2
XX:XX:XX:XX:XX:XX	ethWAN
...
```

Don't forget to modify `/etc/config/network`


# AdGuard Home + dnsmasq + OpenClash

***DO NOT TRY THIS AT HOME!!! THIS IS MISLEADING BUT IT WORKS FOR NOW AND I AM TAKING NOTES FOR MYSELF***

> --> [53] AdGuardHome --> [1745] dnsmasq --> [1053] OpenClash

AdGuardHome as ad filter, dnsmasq as local domain hijacking, OpenClash as proxy and DNS traffic redirector

## AdGuard Home

Should listen on 53 (Enable redirection like below, dnsmasq is automatically adjusted to 1745). 

Next DNS of AdGuardHome should point to dnsmasq (1745)

![image](https://user-images.githubusercontent.com/16266909/235281057-f069aec1-109a-4585-b13d-187ecdfc0386.png)
![image](https://user-images.githubusercontent.com/16266909/235281079-04dfd77b-53cd-43ff-88ab-dc2cb4718fb1.png)

## Dnsmasq

As mentioned before, AdGuard Home LuCI should automatically change the listening port of dnsmasq to 1745 under replace mode.

Next DNS of dnsmasq should point to OpenClash (1053)

Uncheck the two checkboxes in the advanced settings or OpenClash can't obtain the domain name (unsure if it's because these two options but very likely)

![image](https://user-images.githubusercontent.com/16266909/235281165-202a07de-0eb5-4cf0-b95c-1265e3a77673.png)
![image](https://user-images.githubusercontent.com/16266909/235281176-30fd16fc-16f1-470b-ade2-6daa82124962.png)

## OpenClash

Use 7-6-1 and 7-6-2 to set the NameServer DNS and Fallback DNS

Use 7-6-7 in CLI to disable local DNS hijacking (after doing this the local DNS menu option should say "disabled". Actually it's not, but the CLI says so and prevents you from accessing the DNS settings until you re-enable it? Not sure, just set the DNS servers before this step)

![image](https://user-images.githubusercontent.com/16266909/235281317-1ba435e0-68e0-47e9-a076-de32a4a6c8d9.png)

## DHCP

Point published DNS server to OpenWrt and done.

![image](https://user-images.githubusercontent.com/16266909/235281367-5258a699-3d3a-45aa-9845-edbb087e0217.png)
