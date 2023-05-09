# HAVE TO DISABLE MODULE SIGNING AND RECOMPILE NEW KERNEL THAT CANNOT BE UPGRADED

## According to readme, need to recompile kernel

> 1. Need to disable the original 8250 driver for 99xx chips
> 2. Need to disable module signature verification

```bash

# Download source

apt install libssl-dev libelf-dev dwarves
apt install linux-source
cd /usr/src
tar -axvf linux-source-5.10.tar.xz
cd linux-source-5.10

# Copy and modify current config

cp /boot/config-$(uname -r) ./.config
nano .config
# Find "CONFIG_MODULE_SIG=y", set to "n"
# Find "CONFIG_MODULE_SIG_ALL is not set", set to "n"
# Find "CONFIG_SYSTEM_TRUSTED_KEYS", set to empty string

# Edit source to disable builtin 8250 driver

nano drivers/tty/serial/8250/8250_pci.c
# Go to around line 5646, find the defines with "PCI_DEVICE_ID_NETMOS_99xx"
# Comment them all


```

## Download and unzip driver pack

https://asix.com.tw/en/product/Interface/PCIe_Bridge/MCS9900

> Linux kernel 4.x/3.x/2.6.x Driver

```bash
tar -zxvf MCS99xx_LINUX_Driver_v3.1.0_Source.tar.gz
cd MCS99xx_LINUX_Driver_v3.1.0_Source

nano Makefile
# Change "ifeq ($(MAJORVERSION),4)" on line 10 to "5"
# Change "SUBDIRS" on line 32 to "M"

make
make install
echo "99xx" > /etc/modules-load.d/mcs99xx.conf
```
