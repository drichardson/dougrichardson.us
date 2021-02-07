---
layout: note
title: Installing Debian on a 2008 MacBook
date: 2021-02-07 11:28:17 -0800
---

I have a [MacBook (13-inch, Aluminum, Late
2008)](https://apple-history.com/mb_late_08) that is too old to run recent
versions of macOS, but I was able to install the latest version of Debian, 
and run up to date Firefox and Chrome.

# Recommended: Replace HDD with SSD

The MacBook had a HDD which is pretty slow. I swapped it out for a 25 USD SSD drive and got much better overall performance, especially notible at reducing boot times.

The SSD I got was a [Kingston 120GB A400 SATA 3 2.5" Internal SSD
SA400S37](https://www.kingston.com/us/ssd/a400-solid-state-drive).

# Note on sub-par Wireless Performance

For some reason, even though the wireless is capable of 802.11n, I'm only
getting around 14Mbps up and down in my iperf3 tests. Wired networking is much
faster. It isn't clear what is limiting the wireless network rate, but perf
(not iperf) reports that read_hpet (high percision event timer) is
consuming most of the cpu (though that may be a perf artifact, not sure).

# Debian Install

1. Download Debian [netinst image for amd64](https://www.debian.org/CD/netinst/).
1. Flash the ISO onto a USB driver. I was on Windows 10 and used [Balena Etcher](https://www.balena.io/etcher/).
1. Plug MacBook into network with Ethernet cable. You won't have WiFi until
   after install.
1. Boot MacBook, holding option key so you can select boot disk.
1. Insert USB drive. At this point, boot options should appear. Select one and
   boot.
1. Complete Debian install, with the following choices:
    - During Partition/Disk Setup, select Disk Encryption if you like (though
      you will have to enter a password at each boot to unlock the disk).
    - When prompted for disk for non-free WiFi drivers, skip. Will get back to
      this later.
    - Select xfce Window Manager. It's lightweight and works well with the old
      MacBook hardware.
1. After install, remove USB drive and reboot.


# Setup Wifi

1. Create a file called /etc/apt/sources.list.d/my-non-free.list with the
   following contents:

    deb http://deb.debian.org/debian buster contrib non-free
    deb-src http://deb.debian.org/debian buster contrib non-free

1. apt-get update
1. apt-get install firmware-b43-installer
1. Add the following 2 lines to /etc/network/interfaces:

   allow-hotplug wlan0
   iface wlan0 inet dhcp

1. apt-get install wicd
1. Use Wicd to connect to WiFi network. You will need to go to Wicd preferences
   and add wlan0 as the wifi network device.

# NVIDIA driver issue when updating to Debian 10.8

After updating to 10.8, xfce Window Manager wouldn't show the login screen,
the main screen was suck on a blinking cursor, but I could still use the
computer buy [switching to another TTY with alt+control+F2](https://wiki.debian.org/Console).

[dmesg](https://man7.org/linux/man-pages/man1/dmesg.1.html) showed an NVIDIA
driver warning about my old graphics card no longer being supported. This issue
is also [described
here](https://wiki.debian.org/NvidiaGraphicsDrivers#Driver_stops_working_after_upgrading_Debian).

Rather than installing the legacy NVIDIA driver, I installed the open source
[nouveau](https://nouveau.freedesktop.org/) driver which seems to work fine
for general web browser use and zoom calling. I went with the nouveau driver
because I believe it will be maintained longer than the proprietary NVIDIA
drivers.

After doing this, I was able to purge all the *nvidia* packages.

    sudo apt-get purge '^nvidia-.*'
    sudo apt-get autoremove
