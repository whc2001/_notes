# Passthrough Optical Drive
~~> https://www.smetana.name/blog/2014/10/20/sharing-dvd-drive-over-iscsi/~~

~~Use `/dev/sg*` instead of `/dev/sr*`~~

DO NOT TRY. EVERYTHING WILL HANG/CRASH BOTH END REALLY BAD

# Mount / Unmount with Services Depending On

## Install Open-iSCSI, configure the connection and auto login

```sh
apt update
apt install open-iscsi
iscsiadm -m discovery -t st -p <target_ip>
iscsiadm -m node -T <target_iqn> -p <target_ip> --login
iscsiadm -m node -T <target_iqn> -p <target_ip> --op update -n node.startup -v automatic
```

Now the block device should appear in /dev

## Configure auto mount with `fstab`

```sh
echo "/dev/<iscsi_device>	/mnt/<mount_point>	ext4	_netdev	0	0" >> /etc/fstab
```

## Schedule services depending on it

Configure the following to the systemd service

```
[Unit]
After=... remote-fs.target
RequiresMountsFor=/mnt/<mount_point>
```
