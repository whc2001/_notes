# No auto adjust hostname and hosts in container
`touch /etc/.pve-ignore.hostname`
`touch /etc/.pve-ignore.hosts`

# Change VMID
> https://forum.proxmox.com/threads/changing-vmid-of-a-vm.63161/post-467098
```bash
#!/usr/bin/env bash

export oldVMID=$1 newVMID=$2 vgNAME="pve";

vms=$(qm list);
cts=$(pct list);
oldType=""

# Fetch the type for old VMID
if [[ $(echo $vms | grep $oldVMID &> /dev/null; echo $?) -eq 0 ]]; then
  oldType="VM"
elif [[ $(echo $cts | grep $oldVMID &> /dev/null; echo $?) -eq 0 ]]; then
  oldType="CT"
fi

# Check if the old VMID exists, if not then exit
if [[ -z $oldType ]]; then
    echo "Can't find old VMID $oldVMID"
    exit 1
fi

# Check if the new VMID exists, if so then exit
if [[ $(lvs -a | grep "vm-$newVMID-disk" &> /dev/null; echo $?) -eq 0 ]] \
    || [[ $(ls /etc/pve/qemu-server/$newVMID.conf &> /dev/null; echo $?) -eq 0 ]] \
    || [[ $(ls /etc/pve/lxc/$newVMID.conf &> /dev/null; echo $?) -eq 0 ]]; then
  echo "New VMID $newVMID already exists"
  exit 1
fi

echo "Renaming disks"
for i in $(lvs -a | grep $vgNAME | awk '{print $1}' | grep $oldVMID);
do
  lvrename /dev/$vgNAME/vm-$oldVMID-disk-$(echo $i | awk '{print substr($0,length,1)}') /dev/$vgNAME/vm-$newVMID-disk-$(echo $i | awk '{print substr($0,length,1)}')
done

echo "Renaming config"
if [[ $oldType == "VM" ]]; then
  sed -i "s/$oldVMID/$newVMID/g" /etc/pve/qemu-server/$oldVMID.conf
  mv /etc/pve/qemu-server/$oldVMID.conf /etc/pve/qemu-server/$newVMID.conf
else
  sed -i "s/$oldVMID/$newVMID/g" /etc/pve/lxc/$oldVMID.conf
  mv /etc/pve/lxc/$oldVMID.conf /etc/pve/lxc/$newVMID.conf
fi

unset oldVMID newVMID vgNAME;

```

# Unmount before shutdown NAS VM:
https://ruhnet.co/blog/recursive-storage-proxmox-using-nfs-or-iscsi-provided-virtualized-truenas-guest

# ?
https://forum.proxmox.com/threads/cpu-soft-lockup-after-vm-win10-shutdown.70481/#post-317249
https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E8%99%9A%E6%8B%9F%E6%9C%BA%E5%85%B3%E9%97%AD%E4%B9%8B%E5%90%8E%E5%AE%BF%E4%B8%BB%E6%9C%BA%E6%A0%B8%E5%BF%83%E6%97%A0%E5%93%8D%E5%BA%94
