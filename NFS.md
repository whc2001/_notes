`/etc/systemd/system/mnt-data.mount`
```
[Unit]
Description=Mount NFS Share
After=network.target remote-fs.target
Requires=network.target remote-fs.target

[Mount]
What=server:/path/to/share
Where=/mnt/data
Type=nfs
Options=defaults

[Install]
WantedBy=multi-user.target
```
`/etc/systemd/system/mnt-data.automount`
```
[Unit]
Description=Automount NFS share

[Automount]
Where=/mnt/data

[Install]
WantedBy=multi-user.target
```

```
systemctl daemon-reload
systemctl enable mnt-data.mount
systemctl enable mnt-data.automount
systemctl start mnt-data.automount
```

On Services:
```
[Unit]
Requires=mnt-data.mount
After=mnt-data.mount
```
