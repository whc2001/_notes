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
        defName="eth$(echo -n $deviceMAC | sed "s/://g" | tail -c 4 | tr "a-z" "A-Z")"
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
