# Set ZFS ARC Size

Adjust `pct` to set maximum memory usage percentage for ZFS

```
grep '^MemTotal' /proc/meminfo | awk -v pct=90 '{printf "%d", $2 * 1024 * (pct / 100.0)}' > /sys/module/zfs/parameters/zfs_arc_max; echo "$((8*1024*1024*1024))" > /sys/module/zfs/parameters/zfs_arc_sys_free
```

![image](https://github.com/whc2001/_notes/assets/16266909/cba86041-0d41-4767-b889-b9dc5aef3ee8)

# Reverse Proxy WebUI with Different Port

Resolves the problem that `https://xxx:12345` -> `https://xxx/ui` instead of `https://xxx:12345/ui`


Assume FreeNAS instance at `1.2.3.4:80`

```
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;

proxy_redirect http://1.2.3.4:80/ /;
proxy_redirect http://xxx/ui/ https://xxx:48877/ui/;
```
