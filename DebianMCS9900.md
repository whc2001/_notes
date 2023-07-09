# ~~HAVE TO DISABLE MODULE SIGNING AND RECOMPILE NEW KERNEL THAT CANNOT BE UPGRADED~~

## Download and unzip driver pack

https://asix.com.tw/en/product/Interface/PCIe_Bridge/MCS9900

> Linux kernel 4.x/3.x/2.6.x Driver

```bash
tar -zxvf MCS99xx_LINUX_Driver_v3.1.0_Source.tar.gz
cd MCS99xx_LINUX_Driver_v3.1.0_Source

nano Makefile
# Change the 4 in "ifeq ($(MAJORVERSION),4)" on line 10 to the current kernel major version you have, e.g., "5" or "6"
# Change "SUBDIRS" on line 32 to "M"

# >>>>> IF YOU ARE ON KERNEL 6.X, FOLLOW THE "New change on kernel 6.X" SECTION BELOW NOW!!!! <<<<<

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

## New change on kernel 6.X

There are some API changes on 6.x, so we need to modify more

### set_termios and MODULE_SUPPORTED_DEVICE
```
nano 99xx.c

# Search "serial99xx_set_termios"
# Change "struct ktermios *old" to "const struct ktermios *old"

# Navigate to the end of the file
# Comment out the line starts with "MODULE_SUPPORTED_DEVICE"
```

### PCI DMA API Major Change

On kernel 6.x the PCI DMA API has changed a lot:

https://lore.kernel.org/lkml/20220106222804.GA330366@bhelgaas/t/

However we can change it to the new API easily:

https://lore.kernel.org/kernel-janitors/20200716192821.321233-1-christophe.jaillet@wanadoo.fr/

You can use the patch above, or follow the patch content to modify the function calls. 

- `pci_alloc_consistent` -> `dma_alloc_coherent`
- `pci_free_consistent` -> `dma_free_coherent`
- The first parameter need to go one layer deeper, original is `dev` now should be `&dev->dev`
- The last parameter of the new API (the `GFP_`) can simply be `GFP_KERNEL`

## Customize names

The default device name is `ttyF*` and driver name is `saturn`, which may not be clear enough.

Find `starex_serial_driver` in `99xx.c`, and you can change the values in `driver_name` and `dev_name`. Here is an example:

```c
static struct uart_driver starex_serial_driver = {
        .owner                  = THIS_MODULE,
        .driver_name            = "MCS9900 vendor driver",
        .dev_name               = "ttyMCS",
        .major                  = 200,
        .minor                  = 0,
        .nr                     = UART99xx_NR,
        .cons                   = NULL,
};
```
