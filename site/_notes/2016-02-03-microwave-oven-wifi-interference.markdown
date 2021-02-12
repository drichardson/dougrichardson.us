---
layout: post
title: "Measuring Microwave Oven Wi-Fi Interference"
mathjax: true
---
When my microwave oven is turned on my Wi-Fi performance sometimes suffers.

- Is the microwave oven interfering with my Wi-Fi network?
- Is the microwave oven safe?

The first question can be answered by comparing Wi-Fi performance with the microwave oven on and off.

The second question is more difficult to answer. Even defining the level of safety is not straightforward.

# File Transfer Test
The first test transfers a 1GB[^1] file over Wi-Fi. First setting a baseline with the microwave oven
off and then trying again with the microwave oven on.

## Setup

Generate 1GB, 100MB, and 10MB random files. I'm using a random file here in case there is any other part of the system that
might attempt to compress the file data.

    dd if=/dev/urandom of=~/Desktop/random_1000mb count=1000 bs=1000000
    dd if=/dev/urandom of=~/Desktop/random_100mb count=100 bs=1000000
    dd if=/dev/urandom of=~/Desktop/random_10mb count=10 bs=1000000

My Wi-Fi router has an option to attach a USB hard drive. I'll be using that for my file transfer test. The
USB hard drive is mounted on my laptop using [AFP](https://en.wikipedia.org/wiki/Apple_Filing_Protocol).

             wifi                usb
    Laptop <-----> Wi-Fi Router <---> Hard Drive

The Wi-Fi router's 2.4GHz is on channel 9, since channel 9s center frequency (2.452GHz) is the closest
to my microwaves specified operating frequency (2.45GHz).

Change the working directory to the mounted AFP drive:

    cd <PATH_TO_MOUNTED_AFP_DRIVE>

## Test 1: Microwave Oven Off

### 1GB File
    $ rsync --progress ~/Desktop/random_1000mb out
    random_1000mb
    1000000000 100%    6.58MB/s    0:02:25 (xfer#1, to-check=0/1)
    
    sent 1000122155 bytes  received 42 bytes  6873692.08 bytes/sec
    total size is 1000000000  speedup is 1.00


### 100MB File

    $ rsync --progress ~/Desktop/random_100mb out
    random_100mb
    100000000 100%    6.01MB/s    0:00:15 (xfer#1, to-check=0/1)
    
    sent 100012295 bytes  received 42 bytes  4444992.76 bytes/sec
    total size is 100000000  speedup is 1.00


### 10MB File (3 times)

    $ rsync --progress ~/Desktop/random_10mb out
    random_10mb
        10000000 100%    8.73MB/s    0:00:01 (xfer#1, to-check=0/1)
    
    sent 10001310 bytes  received 42 bytes  4000540.80 bytes/sec
    total size is 10000000  speedup is 1.00
    $ rsync --progress ~/Desktop/random_10mb out
    random_10mb
        10000000 100%   10.17MB/s    0:00:00 (xfer#1, to-check=0/1)
    
    sent 10001310 bytes  received 42 bytes  4000540.80 bytes/sec
    total size is 10000000  speedup is 1.00
    $ rsync --progress ~/Desktop/random_10mb out
    random_10mb
        10000000 100%    9.38MB/s    0:00:01 (xfer#1, to-check=0/1)
    
    sent 10001310 bytes  received 42 bytes  6667568.00 bytes/sec
    total size is 10000000  speedup is 1.00

The fastest was 10.17MB/s and the slowest was 8.73MB/s.

## Test 2: Microwave Oven On

### 1GB File
I started the second test with the microwave on, but had to abort. After a few minutes of running,
rsync estimated it'd be about 50 minutes until the transfer completed. More importantly,
while I was running the microwave
I had the thought that running it with nothing inside of it might not be exactly what the microwave
oven designers intended.

Sure enough, I opened the microwave and it was very warm inside and the oven itself was unusually hot.

Perhaps the [purposes of my life is to serve as a warning to others](http://despair.com/products/mistakes).

### 100MB File
After letting the microwave oven cool, I filled a large, microwave safe bowl with cool water and
turned on the microwave. Once again, the rsync estimated the test was going to take several minutes
to complete, so I aborted the test (not wanting to run the microwave for several minutes with the
bowl of water I was using).


### 10MB File (3 times)

    $ rsync --progress ~/Desktop/random_10mb out
    random_10mb
        10000000 100%  957.75kB/s    0:00:10 (xfer#1, to-check=0/1)
    
    sent 10001310 bytes  received 42 bytes  869682.78 bytes/sec
    total size is 10000000  speedup is 1.00
    $ rsync --progress ~/Desktop/random_10mb out
    random_10mb
        10000000 100%  580.70kB/s    0:00:16 (xfer#1, to-check=0/1)
    
    sent 10001310 bytes  received 42 bytes  571505.83 bytes/sec
    total size is 10000000  speedup is 1.00
    $ rsync --progress ~/Desktop/random_10mb out
    random_10mb
        10000000 100%  362.63kB/s    0:00:26 (xfer#1, to-check=0/1)
    
    sent 10001310 bytes  received 42 bytes  363685.53 bytes/sec
    total size is 10000000  speedup is 1.00

The fastest was 957.75kB/s and the slowest was 362.63kB/s.


### File Transfer Summary
File transfer was more than 10x faster when the microwave oven was off. So, yes, operating the
microwave oven affects Wi-Fi network performance.

# Signal/Noise Test
The second test looks at the Wi-Fi signal and the [noise floor](https://en.wikipedia.org/wiki/Noise_floor).

## Test 1: Microwave Oven Off

![Graph of Signal and Noise when Oven is Off](/assets/posts/microwave-oven/noise-microwave-off.png)

The max noise was -82.5dBm.

## Test 2: Microwave Oven On

![Graph of Signal and Noise when Oven is On](/assets/posts/microwave-oven/noise-microwave-on.png)

The max noise was -77.5dBm.

## Signal/Noise Test Summary
Because I didn't have raw data, computing more characteristics of the noise is not straightforward. However,
just eyeballing it, there appears to be higher peaks in the noise when the oven is on.

Also, it isn't clear to me how the Wi-Fi signal is measured. I'm assuming it's measuring the power
of 2.4GHz but I don't know much about RF measurements so perhaps it's something else entirely.

If it's a measure of power at 2.4GHz, then most of the power coming from the microwave oven
would look like signal, not noise.

# Notes
Here are some notes I made while coming up with the tests.

## Wi-Fi Environment
I have a dual band 2.4GHz/5GHz 802.11b/n/ac Apple Airport Extreme.
I'm able to reliably use 2.4GHz throughout my home, while the 5GHz only works reliably
in some parts of the home. Since both 802.11n and 802.11ac can operate on 5GHz, it isn't clear
to me if this reliability issue is related to the higher 5GHz frequency or related to 802.11n vs. 802.11ac.

However, I noticed that if I'm on 2.4GHz and someone turns on microwave oven that my Wi-Fi sometimes gets laggy.
That makes me wonder:

## Safe Levels of RF

[According to the FCC](https://www.fcc.gov/engineering-technology/electromagnetic-compatibility-division/radio-frequency-safety/faq/rf-safety):

> "Ionization" is a process by which electrons are stripped from atoms and molecules.  This process can produce molecular changes that can lead to damage in biological tissue, including effects on DNA, the genetic material of living organisms.  This process requires interaction with high levels of electromagnetic energy.  Those types of electromagnetic radiation with enough energy to ionize biological material include X-radiation and gamma radiation.  Therefore, X-rays and gamma rays are examples of ionizing radiation.
>
> The energy levels associated with RF and microwave radiation, on the other hand, are not great enough to cause the ionization of atoms and molecules, and RF energy is, therefore, is a type of non-ionizing radiation.  Other types of non-ionizing radiation include visible and infrared light.  Often the term "radiation" is used, colloquially, to imply that ionizing radiation (radioactivity), such as that associated with nuclear power plants, is present.  Ionizing radiation should not be confused with the lower-energy, non-ionizing radiation with respect to possible biological effects, since the mechanisms of action are quite different.

and also

> Biological effects can result from exposure to RF energy.  Biological effects that result from heating of tissue by RF energy are often referred to as "thermal" effects.  It has been known for many years that exposure to very high levels of RF radiation can be harmful due to the ability of RF energy to heat biological tissue rapidly.  This is the principle by which microwave ovens cook food.  Exposure to very high RF intensities can result in heating of biological tissue and an increase in body temperature.  Tissue damage in humans could occur during exposure to high RF levels because of the body's inability to cope with or dissipate the excessive heat that could be generated.  Two areas of the body, the eyes and the testes, are particularly vulnerable to RF heating because of the relative lack of available blood flow to dissipate the excess heat load.

For the purposes of my test, I'm going to define it as "safe" if the received RF signal emitted from the microwave is less than the
signal received from my 2.4GHz access point. That's mainly a practical definition, becuase to escape 2.4GHz Wi-Fi, I'd have to
move to the dark side of the moon.


## Microwave Oven
Many microwave oven's generate 2.4GHz signals, and mine is no exception.
According to the [owner's manual](ftp://ftp.panasonic.com/microwaveoven/om/nn-h624_en_om.pdf),
my Panasonic oven operates at 2450 MHz, or 2.45GHz.

![NN-H624](/assets/posts/microwave-oven/microwave-specs.png)

## 802.11b/g/n Wi-Fi
In the United States, 802.11b and 802.11g/n-2.4 use 11 channels, each centered at a different frequency.
For example, channel 8 is centered at 2.447GHz and 9 is centered at 2.452GHz.

![2.4 GHz 802.11a/b/n channels](/assets/posts/microwave-oven/2.4ghz-wifi-channels.svg)

## Mac OS X Wireless Network Diagnostics
I also discovered that on Mac OS X, if you hold the `Option` button down while selcting the Wi-Fi menu, you can
select *Open Wireless Diagnostics...* which then provides a bunch of tools under the *Window* menu, to do things
like capture Wi-Fi packets into a [pcap file](https://en.wikipedia.org/wiki/Pcap) and display graphs of
the Wi-Fi signal and [noise floor](https://en.wikipedia.org/wiki/Noise_floor).

![Wi-Fi Menu with Option Key Down](/assets/posts/microwave-oven/wifi-menu-option-key-down.png)

![Wireless Diagnostics Window Menu](/assets/posts/microwave-oven/wireless-diagnostics-window-menu.png)

# References
* [Channel spacing within the 2.4 GHz band](https://en.wikipedia.org/w/index.php?title=IEEE_802.11&oldid=859832212#Channel_spacing_within_the_2.4_GHz_band)
* [Panasonic NN-H624BF Microwave Oven](http://shop.panasonic.com/support-only/NN-H624BF.html?t=specs&support)
* [Panasonic NN-H624 Microwave Oven Operating Instructions](ftp://ftp.panasonic.com/microwaveoven/om/nn-h624_en_om.pdf)
* [802.11b/g/n channel drawing](https://commons.wikimedia.org/wiki/File:2.4_GHz_Wi-Fi_channels_(802.11b,g_WLAN).svg)

# Footnotes

[^1]: All values use [metric prefixes](https://en.wikipedia.org/wiki/Metric_prefix), not [binary prefixes](https://en.wikipedia.org/wiki/Binary_prefix). So, 1MB=$$10^6$$ bytes and 1GB=$$10^9$$ bytes.
