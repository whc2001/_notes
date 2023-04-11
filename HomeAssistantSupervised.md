# [Prereq](https://github.com/home-assistant/architecture/blob/master/adr/0014-home-assistant-supervised.md)
## Housekeeping
`systemctl --version`

`nmcli --version`

- `apt install network-manager`
- During installation it will output which port is managed by `ifupdown`
- Remove those from `/etc/network/interfaces`

`dpkg -l udisks2`

`dpkg -l apparmor`

## Docker

`docker --version`

- https://docs.docker.com/engine/install/debian/#install-using-the-repository
> Docker needs to be correctly configured to use overlayfs2 storage, journald as the logging driver with Container name as Tag, and cgroup v1.
- https://docs.docker.com/storage/storagedriver/overlayfs-driver/
- https://docs.docker.com/config/containers/logging/journald/
- `/etc/docker/daemon.json`
```json
{
  "storage-driver": "overlay2",
  "log-driver": "journald",
  "log-opts": {
    "tag": "{{.Name}}"
  }
}
```

- https://www.reddit.com/r/homeassistant/comments/yrflr2/failed_to_switch_to_cgroup_v1_error_on_manual/
- `GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0"` in `/etc/default/grub`
- `update-grub`
- Reboot

- `docker info`
```
 Storage Driver: overlay2
 Logging Driver: journald
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
```

> Systemd journal gateway is enabled and mapped into supervisor as `/run/systemd-journal-gatewayd.sock`

- `apt install systemd-journal-remote`

## Home Assistant OS-Agent

- https://github.com/home-assistant/os-agent

REBOOT!!!

# Install

https://github.com/home-assistant/supervised-installer

