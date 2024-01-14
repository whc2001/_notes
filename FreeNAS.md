# Set ZFS memory

```
grep '^MemTotal' /proc/meminfo | awk -v pct=90 '{printf "%d", $2 * 1024 * (pct / 100.0)}' > /sys/module/zfs/parameters/zfs_arc_max; echo "$((8*1024*1024*1024))" > /sys/module/zfs/parameters/zfs_arc_sys_free
```

![image](https://github.com/whc2001/_notes/assets/16266909/cba86041-0d41-4767-b889-b9dc5aef3ee8)
