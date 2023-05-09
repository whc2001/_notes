# ~~HAVE TO DISABLE MODULE SIGNING AND RECOMPILE NEW KERNEL THAT CANNOT BE UPGRADED~~

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
```

## Free the device from kernel builtin serial driver

https://unix.stackexchange.com/questions/599690/how-to-blacklist-built-in-kernel-module-8250-pci

https://askubuntu.com/questions/1393562/unbind-and-bind-driver-during-startup-20-04-3-lts

Because the support is compiled into the kernel not loaded dynamically, cannot use `remove_id`, only `unbind`. Run `lspci -vv`, check the corresponding devices should say something like `kernel driver in use: serial`, indicates the kernel driver is occupying the device.

Add the following script to startup on boot

```bash
# Disable kernel serial driver on the devices
devices=$(lspci | awk '/MCS9900/ {print "0000:"$1}')
echo "$devices" | while IFS= read -r line; do
    echo "$line" > /sys/bus/pci/drivers/serial/unbind
done

# (Re)load vendor driver
modprobe -r -f 99xx || true
modprobe -f 99xx
```

After reboot do `lspci -vv` again, should say something like `kernel driver in use: saturn` and `/dev/ttyFx` appears, indicates the vendor driver is working.
