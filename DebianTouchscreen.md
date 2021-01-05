https://unix.stackexchange.com/questions/42039/configure-touchscreen-on-debian

## 安装 xinput 相关
    apt install xinput xserver-xorg-input-evdev xinput-calibrator

## 卸载 libinput
    rm /usr/share/X11/xorg.conf.d/40-libinput.conf
    apt remove xserver-xorg-input-libinput

## 列出设备
    xinput list
找到 eGalaxTouch 控制器记住名字

## 配置设备
    nano /usr/share/X11/xorg.conf.d/10-evdev.conf
    
注释掉 Identifier 为 `touchscreen catchall` 的一节，添加如下内容

```
    Section "InputClass"
        Identifier "evdev touchscreen egalax"
        MatchIsTouchscreen "on"
        MatchProduct "上一步记下的控制器完整名称"
        Driver "evdev"
#        Option "Device" "/dev/input/event9" #上一步如果记了 input event id 可以添加这一行，实际上名称够用了
    EndSection
```

- 存在多个设备需要禁用其中一个：添加一节，选项写上`Option "Ignore" "on"`
    
## 校准屏幕
    xinput_calibrator
使用触摸笔依次准确单击四个十字图标中心，完成校准
之后将输出的配置内容保存在/usr/share/X11/xorg.conf.d/99-calibration.conf

## 重启
    systemctl restart lightdm
    
## 配置长按右键单击模拟

参考 https://www.systutorials.com/docs/linux/man/4-evdev/，长按右键模拟是 `EnableThirdButtonEmulation` 相关

在 `/usr/share/X11/xorg.conf.d/10-evdev.conf` 增加的一节里写 Options 即可

如不工作 需要借助第三方工具：https://github.com/PeterCxy/evdev-right-click-emulation

安装：https://fmirkes.github.io/articles/20190827.html
