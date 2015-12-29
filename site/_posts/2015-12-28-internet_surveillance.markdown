---
layout: post
title: Internet Surveillance
---
This article explores a few of the ways you are tracked when you use an
internet connected device.
You may be tracked as part of a government sponsored [mass surveillance program][mass], by
internet network operators, or by unauthorized network intruders.

In the rest of the article, any of these three entities are referred to as eavesdroppers when
they are monitoring or analyzing your data for purposes beyond internet traffic delivery.

# Internet Traffic
In order to transmit data between your computer and a web site, two addresses are needed: the
address of your computer, and the address of the web site you are trying to access. This pair of addresses
is visible (and thus, can be tracked) by every device that sits between your computer and the web site you are trying
to access. At a minimum, this includes your Internet Service Provider (e.g., Comcast) and the website's Internet
Service Provider, but usually traffic passes through other organizations as well. [Appendix B](#appendix-b-traceroute) shows
an example route. These organizations see your traffic and thus have the capability to eavesdrop
on your traffic.

What could an eavesdropper learn about you by looking at your internet traffic?

* An estimate of your physical location using [IP geolocation][geo].
* The number of network messages sent to and from an IP address. A message in this context is a piece
of internet traffic, and is not to be confused with an e-mail or text message (although each of those would be transmitted
using one or more network messages).
* The size of each network message.
* The web site you are visiting. If the web site has it's own IP address (some do, while other web sites share IP addresses with many
web sites) then an eavesdropper will know what web site you're looking at, though they may not know what exact page your looking at.

Suppose you download 3 gigabytes of data from a web site. This might alert an eavesdropper that you are
downloading a movie or a large software package. If the IP address of the site
is also known to be one that, for example, serves pirated movies and software, the eavesdropper would have reason
to believe you are downloading pirated movies or software.

Now suppose you visit a site and that your computer sends many short messages to the web site and the
web site sends many short messages back to your computer. If the site is known to be a text or voice
chat web site, an eavesdropper could infer you're communicating with someone. 

# DNS Names
Usually, when you go to a web site, you don't go there using the site's IP address. Rather, you use
a name. These names are converted into IP addresses by the Domain Name System. Ordinarily,
your Internet Service Provider's DNS servers are used to convert names to IP addresses. Even
if you use another DNS service, your Internet Service Provider can eavesdrop on all DNS requests
your computer makes because DNS traffic is sent in the clear (i.e., DNS traffic is not encrypted).

What could an eavesdropper learn about you by looking at your computers DNS requests?

* The names of the web sites you are visiting (though not the specific pages you are looking at). For example,
if you visit https://embarrassing.com/somepage.html the eavesdropper would know your computer requested
the IP address for embarrassing.com but not that you looked at somepage.html.

# HTTP Traffic
Web pages are transmitted to your computer using a protocol called HTTP (Hypertext Transport Protocol). HTTP has few security protections.
An eavesdropper between your computer and the web site your viewing can also view what you're looking at. To address
this deficiency, HTTPS was developed which ostensibly prevents anyone but you and the web page your viewing from monitoring
your activity.

However, even if you are using HTTPS, the internet traffic message addresses and lengths and DNS names
previously discusses are still observabe.

Additionally, HTTPS relies on a set of root certificates that are pre-installed on your computer. Every web site
has to get their own certificate issued by an owner of one of the pre-installed root certificates. A quick look at my own
computer shows 180 root certificates, many owned by private companies from around the world and some by government
agencies such as the US Department of Defense. Any of these root certificate owners can generate a valid certificate
for any web site on the internet. This gives any root certificate owner the ability to snoop on any web traffic, even
encrypted over HTTPS, provided they get a device between your computer and the web site you're trying to view (which the
US National Security Agency is [known to have been doing][nsa] for some time).

Regardless of the technical aspects of security, governmant agencies force web site owners to share the
encryption keys that keep communications between you and the web site private[^lava], thus allowing agencies to
eavesdrop on anything between your computer and their web site.

# Appendix A: Tools

* [Browser Leaks][] is a tool that lets you see the information leaked when you use the web. For example, click on
the [IP Address][ip] link and the site will show you the ISP they detected and your physical location.
* [Panopticlick][] is a tool developed by the [Electronic Frontier Foundation][eff] to test your web browsers
trackability; that is, how uniquely can your browser and, thus, you, be identified by someone on the network.
* [Bad SSL][selfsigned] shows what an HTTPS protected web page looks like when it is using a certificate not
issued by one of the owners of the root certificates pre-installed on your computer. Note, if you have a good
web browser, you will see an error.
* [HTTPS Everywhere][] is a browser extension developed by the [Electronic Frontier Foundation][eff]
that makes your browser prefer HTTPS versions of web sites you visit over HTTP (insecure) versions of the same site.

# Appendix B: traceroute

[traceroute][traceroute] is a tool used to see how network traffic travels from your computer to some
destination on the internet. The trace below shows the route through the internet that the messages from my computer
will take to the computer hosting the web site for the [Ministry of Foreign Affairs of the People's Republic of China][prc].

    $ traceroute www.fmprc.gov.cn
    traceroute: Warning: www.fmprc.gov.cn has multiple addresses; using 209.177.90.10
    traceroute to webcache.foreign.ccgslb.com (209.177.90.10), 64 hops max, 52 byte packets
     1  10.0.1.1 (10.0.1.1)  2.071 ms  1.150 ms  1.070 ms
     2  50.152.240.1 (50.152.240.1)  9.995 ms  9.642 ms  10.606 ms
     3  te-0-3-0-7-sur03.santaclara.ca.sfba.comcast.net (68.85.191.5)  10.969 ms  13.087 ms  15.553 ms
     4  he-0-3-0-6-ar01.santaclara.ca.sfba.comcast.net (68.87.192.185)  10.447 ms
        hu-0-3-0-5-ar01.santaclara.ca.sfba.comcast.net (68.87.192.181)  12.023 ms
        hu-0-3-0-4-ar01.santaclara.ca.sfba.comcast.net (68.87.192.177)  25.442 ms
     5  * * *
     6  be-10910-cr01.sanjose.ca.ibone.comcast.net (68.86.86.102)  12.124 ms  15.642 ms  12.573 ms
     7  50.242.148.34 (50.242.148.34)  11.604 ms  15.104 ms  11.387 ms
     8  vl-3507.car3.seattle1.level3.net (4.69.200.89)  30.606 ms  29.886 ms  29.706 ms
     9  chinacache.gigabitethernet9-16.ar5.sea1.gblx.net (67.17.210.126)  30.164 ms  33.373 ms  53.727 ms
    10  209.177.90.10 (209.177.90.10)  28.568 ms  61.876 ms  33.238 ms

There are 5 easily identifiable entities in this trace:

1. Me (at address 10.0.1.1),
2. Comcast, my Internet Service Provider
3. Level 3 Communications
4. gblx.net (probably Global Crossings, now owned by Level 3 Communications)
5. webcache.foreign.ccgslb.com (the Ministry of Foreign Affair's web site)

# Footnotes

[mass]: https://en.wikipedia.org/wiki/Mass_surveillance_in_the_United_States
[geo]: https://en.wikipedia.org/wiki/Geolocation_software
[Browser Leaks]: https://www.browserleaks.com/
[ip]: https://www.browserleaks.com/whois
[Panopticlick]: https://panopticlick.eff.org/
[eff]: https://www.eff.org/
[nsa]: https://en.wikipedia.org/wiki/Room_641A
[selfsigned]: https://self-signed.badssl.com/
[^lava]: [Lavabit on Wikipedia](https://en.wikipedia.org/wiki/Lavabit)
[HTTPS Everywhere]: https://www.eff.org/https-everywhere
[traceroute]: https://en.wikipedia.org/wiki/Traceroute
[prc]: http://www.fmprc.gov.cn/mfa_eng/
