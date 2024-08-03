# Set ZFS ARC Size

Adjust `pct` to set maximum memory usage percentage for ZFS

```
grep '^MemTotal' /proc/meminfo | awk -v pct=90 '{printf "%d", $2 * 1024 * (pct / 100.0)}' > /sys/module/zfs/parameters/zfs_arc_max; echo "$((8*1024*1024*1024))" > /sys/module/zfs/parameters/zfs_arc_sys_free
```

![image](https://github.com/whc2001/_notes/assets/16266909/cba86041-0d41-4767-b889-b9dc5aef3ee8)

# Reverse Proxy WebUI with Different Port

~~Resolves the problem that `https://xxx:12345` -> `https://xxx/ui` instead of `https://xxx:12345/ui`~~


~~Assume FreeNAS instance at `1.2.3.4:80`~~

Problem related to NginxProxyManager, need to manually change config file to put `$http_host` in the bottom. See [nginx-proxy-manager/3729](https://github.com/NginxProxyManager/nginx-proxy-manager/pull/3729)

# Watch UDMA Error State

`watch -n 1 -t 'for d in /dev/sd?; do v=$(smartctl -A $d | awk "/UDMA_CRC_Error_Count/ {print \$NF}"); [ -n "$v" ] && echo "$d: $v"; done'`
