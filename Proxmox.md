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

# Check if the old ID exists, if not then exit
if [[ -z $oldType ]]; then
    echo "Can't find VMID $oldVMID"
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
  #lvrename /dev/$vgNAME/vm-$oldVMID-disk-$(echo $i | awk '{print substr($0,length,1)}') /dev/$vgNAME/vm-$newVMID-disk-$(echo $i | awk '{print substr($0,length,1)}')
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
