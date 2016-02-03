---
layout: post
title: "Microwave Oven RF Interference"
---
I have a dual band 2.4GHz/5GHz Wi-Fi
access point, though I'm able to use 2.4GHz more consistently throughout my house, so I generally leave it there unless
I want to maximize my throughput, at which point I'll switch over to 5GHz.

However, I noticed that if I'm on 2.4GHz and someone turns on microwave oven that my Wi-Fi gets very laggy. Sometimes
unuseably laggy.

Many microwave oven's generate 2.4GHz signals, and mine is no exception. Specifically, my Panasonic oven operates
at 2450 MHz, or 2.45GHz.

[According to wikipedia](https://en.wikipedia.org/wiki/IEEE_802.11#Channel_spacing_within_the_2.4.C2.A0GHz_band),
802.11g channel 8 is centered at 2.447GHz and 9 is centered at 2.452GHz.

I also discovered that on Mac OS X, if you hold the `Option` button down while selcting the Wi-Fi menu, you can
select *Open Wireless Diagnostics...* which then provides a bunch of tools under the *Window* menu, to do things
like capture Wi-Fi packets into a [pcap file](https://en.wikipedia.org/wiki/Pcap) and display graphs of
the Wi-Fi signal and [noise floor](https://en.wikipedia.org/wiki/Noise_floor).

# The Test


### References
* [Channel spacing within the 2.4 GHz band](https://en.wikipedia.org/wiki/IEEE_802.11#Channel_spacing_within_the_2.4.C2.A0GHz_band)
* [Panasonic NN-H624BF Microwave Oven](http://shop.panasonic.com/support-only/NN-H624BF.html?t=specs&support)
* [Panasonic NN-H624 Microwave Oven Operating Instructions](ftp://ftp.panasonic.com/microwaveoven/om/nn-h624_en_om.pdf)
