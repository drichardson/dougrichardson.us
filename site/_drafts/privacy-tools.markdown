---
layout: post
title: "Privacy Tutorial"
---
This is an attempt to share knowledge and tips on how to keep your personal data
private.

Even if you aren't worried yourself about what governments and corporations know about you
now, it's still a good idea exercise your rights to privacy, for the same reason the US Navy
conducts freedom of navigation exercises and UK citizens exercise their right to roam: if you
don't regularly exercise your rights and freedoms, they can go away without you realizing it.

First, I'm going to discuss some of the technical details required to better understand
the mechanisms corporations and and governments use to collection information about you.

Second, I'm going to discuss 

# Outline

1. Motivation
1. Background
    1. Technologies
        1. IP
        1. DNS
        1. Web Browsers, Web Servers, and Encryption (Transport and Disk)
        1. Cookies
        1. Trackers
        1. Search Engines
        1. Social Networks
  1. ISPs, Cloud Providers, Governments
  1. Ancestry and DNS Testing Companies
  1. Information Seen
     1. IP messages (sender, receiver, payload). Seen by anyone between sender and receiver.
     1. DNS messages (name to IP). Seen by DNS resolver, which is typically your ISP.
     1. HTTP. All data between sender and receiver is visible to anyone in between.
     1. HTTPS. Data between sender and receiver is encrypted.
     1. End to End encryption. Any encryption scheme where only the sender and receiver can see the content of a message. HTTPS is an example of end to end encryption between the web server
     1. Search.
        1. Whenever you go to a website and enter search terms, that search engine can record what you are doing and other information about you it has (such as IP address).
        1. If you use the search bar built into your browser, the search engine also has access to these data.
 1. Private Communications
    1. Email: Use a paid mail service you trust. Don't use an advertising supported service. I use ProtonMail. Ideally the service also supports end to end encryption, does not keep logs, and eliminates or reduces the window of time they have access to your content as small as possible.
    1. Messaging: Use a service that uses end to end encryption by default. Signal. Telegram.
1. Web Browsing
    1. Firefox, Safari

# Privacy Invasive Business Models
When you use a free site like Google or Facebook or watch television, you are the product, not the consumer. Advertisers are the consumers (the ones who pay money for) of these services who they pay to access you. It is in
the financial interest of advertising companies to know as much about their audience as possible in order to
sell more effective (and therefore more valuable) advertisements.

If you want a tool where you are the customer, you're going to have to pay for it. There is just no way around it.
The businesses need to make money and it's either going to be from you or from someone else,a nd if it's from
someone else it's going to be advertising based.


# Google
If you have a Google account, you can use their [Privacy Checkup](https://myaccount.google.com/privacycheckup)
feature to see some of the data they have on you. You can also choose to delete data and limit what they collect.

[Google Chrome Privacy Notice](https://www.google.com/intl/en/chrome/privacy/)
[Google Privacy Policy](https://policies.google.com/privacy)

## Google Products
- Google Search - most popular search engine
- [Google AdWords](https://ads.google.com) - Purchase advertisements on Google's advertising network. Google's primary source of revenue.
- [Google AdSense](https://google.com/adsense) - Publishers Google Advertisements on non-Google sites (and shares ad revenue with those sites). Another large source of revenue for Google.
- YouTube - most popular video sharing site
- YouTube Music - music subscription service
- Google Chrome - most popular web browser for desktops and mobile phones
- Gsuite - web based productivity tools: word processing, spreadsheet, presentation, drawing, and file storage.
- Google Photos
- Google Contacts
- Google Maps
- Gmail - web based e-mail
- Google Calendar
- Google Hangouts - messaging service
- Google Cloud Platform - Google's cloud platform, used by many internet companies
- Android - Google's smart phone operating system
- Nest - internet connected home automation products

Let's assume you:
- use a Samsung phone (which uses Android)
- use Chrome web browser on your desktop (you installed it)
- use Chrome web browser on your Samsung phone (the default)
- use Google search (the default search engine for Chrome desktop and mobile)
- get directions using Google Maps on your phone
- backup your phone's photos using Google Photos
- store contacts in Google Contacts
- call friends and family from you phone
- use Google docs for work
- use Google calendar are your primary and work calendar
- watch YouTube videos on your phone and desktop
- listen to music from YouTube and YouTube music

Now consider all the information available in the data involved in those services. Google has the potential
to know or infer:

- where you live, work, exercise, dine, shop, vacation (Google Maps)
- contact information for your friends, family, and acquantances (Google Contacts)
- know about almost everything you've ordered online and where it is being delivered to (Gmail - via standard online shopping e-mail receipts and package tracking e-mail notification)
- when (and possibly where and with whom) you have scheduled meetings (Google Calendar)
- your smartphone call history (via Android)
- what videos you like to 
- what music you listen to on YouTube and YouTube music

## Facebook Properties

[Facebook Privacy Policy](https://www.facebook.com/about/privacy)

- Facebook
- Instagram
- WhatsApp

# Apple
[Apple Privacy Policy](https://www.apple.com/privacy/)

## Apple Properties

# Government Actors


- [US \| National Security Agency (NSA)](https://www.nsa.gov/) - known to conduct warrantless dragnet operations on US and non-US cizitens.
  - [A Guide to What We Now Know About the NSA's Dragnet Searches of Your Communications](https://www.aclu.org/blog/national-security/secrecy/guide-what-we-now-know-about-nsas-dragnet-searches-your)
  - [New York Times | N.S.A. Said to Search Content of Messages to and From U.S.](https://www.nytimes.com/2013/08/08/us/broader-sifting-of-data-abroad-is-seen-by-nsa.html)

- [UK \| Government Communication Headquarters (GCHQ)](https://www.gchq.gov.uk/)

- [China \| Ministry of State Security](https://en.wikipedia.org/wiki/Ministry_of_State_Security_(China))

# Tools I'm Using
- [ProtonMail](https://protonmail.com/)
- [ProtonVPN](https://protonvpn.com/)
- [Firefox](https://www.mozilla.org/en-US/firefox/)
- [DuckDuckGo](https://duckduckgo.com/)
- [Privacy Badger](https://www.eff.org/privacybadger)
- [DuckDuckGo Privacy Essentials](https://addons.mozilla.org/en-US/firefox/addon/duckduckgo-for-firefox/)
- [Signal](https://www.signal.org/)
- [1Password](https://1password.com)


# Reference

## Privacy Advocates
- [Electronic Frontier Foundation](https://www.eff.org/issues/privacy)
- [American Civil Liberties Union](https://www.aclu.org/issues/privacy-technology)
- [Bruce Schneier](https://www.schneier.com/) - well known computer security professional and privacy specialist

## Privacy Laws

### Europe
- [EU GDRP | European Union General Data Protection Regulation](https://eugdpr.org/)

### United States
- [Privacy Act of 1974](https://www.justice.gov/opcl/privacy-act-1974)
- [California Consumer Privacy Act of 2018 (CCPA)](https://www.oag.ca.gov/privacy/ccpa)
- [Health Insurance Portability and Accountability Act of 1996 (HIPPA)](https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html)

### Canada
- [Summary of privacy laws in Canada](https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/02_05_d_15/)
