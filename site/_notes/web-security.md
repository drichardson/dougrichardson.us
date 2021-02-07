---
layout: note
title: Web Security
date: 2021-02-01 11:51:55 -0800
---

List of HTTP client and server security tools, technologies, and techniques. 

# Content-Security-Policy



From Mozilla's [Content-Security-Policy Response Header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) document:

> The HTTP Content-Security-Policy response header allows web site
> administrators to control resources the user agent is allowed to load for a
> given page. With a few exceptions, policies mostly involve specifying server
> origins and script endpoints. This helps guard against cross-site scripting
> attacks (XSS).

Also see Mozilla's [Content Security Policy (CSP)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP).

nginx configuration I have used for this site. Note this is very site specific.

```
# Content Security Policy
set $csp "default-src 'none'";
set $csp "$csp; base-uri 'none'";
set $csp "$csp; connect-src 'self'";
set $csp "$csp; font-src 'self'";
set $csp "$csp; form-action 'none'";
set $csp "$csp; frame-ancestors 'none'";
set $csp "$csp; frame-src https://www.youtube.com";
set $csp "$csp; img-src 'self'";
set $csp "$csp; script-src 'self' 'unsafe-inline'";
set $csp "$csp; style-src 'self' 'unsafe-inline'";
add_header Content-Security-Policy $csp;
```

# Referrer-Policy

The [Referrer Policy](https://infosec.mozilla.org/guidelines/web_security#referrer-policy)
tells the browser when it should send the
[Referer](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer)
request header to other sites. This informs the other site that the browser has
just come from your site. You can improve privacy by using the `no-referrer`
policy.

nginx configuration:

```
add_header Referrer-Policy "no-referrer";
```

# X-Content-Type-Options

The
[X-Content-Type-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options)
response header can be used to tell the browser to opt out of [MIME
sniffing](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types#mime_sniffing),
a technique that is unnecessary if content types are configured properly.

nginx configuration:

```
add_header X-Content-Type-Options "nosniff";
```

# Let's Encrypt 

[Let's Encrypt](https://letsencrypt.org/) is a free, automated, and open
[Certificate Authority](https://en.wikipedia.org/wiki/Certificate_authority).
Use can use it to get a free TLS certificate for your website.

Let's Encrypt issues short lived certificates that are intended to be
automatically renewed. One of the methods for automating this is via
[certbot](https://certbot.eff.org/).

- [Certbot Documentation](https://certbot.eff.org/docs/intro.html)
- [Where are my certificates?](https://certbot.eff.org/docs/using.html#where-are-my-certificates)

# Tools

- [Mozilla Observatory](https://observatory.mozilla.org) - scan your web site
  and get a security rating with feedback on what you can do to improve.
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org)

## `openssl s_client`

[OpenSSL's s_client](https://www.openssl.org/docs/manmaster/man1/openssl-s_client.html)
command can be used to inspect the TLS configuration of a server from a clients
point of view.

Connect to a server, optionally specifying the version of the TLS protocol
you'd like to use:

```bash
openssl s_client -connect dougrichardson.us:443
openssl s_client -connect dougrichardson.us:443 -tls1
openssl s_client -connect dougrichardson.us:443 -tls1_1
openssl s_client -connect dougrichardson.us:443 -tls1_2
openssl s_client -connect dougrichardson.us:443 -tls1_3
```

# References

- [Mozilla Web Security Guidelines](https://infosec.mozilla.org/guidelines/web_security)
- [nginx add_header directive](https://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header)

