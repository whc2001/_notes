# Data dir over NFS

- Enable `Allow non-root mount` in NFS service settings
- Add `user: NFSUID:NFSGID` to container `postgres`
- Comment out `volume` section, change the volume mounting for each container to the NFS mount path
