---
layout: post
title: "Web Security"
---

List of some web security tools, technologies, and techniques. 




# Browser Controls

# Content-Security-Policy


From Mozilla's [Content-Security-Policy Response Header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) document:

> The HTTP Content-Security-Policy response header allows web site administrators to control resources the user agent is allowed to load for a given page. With a few exceptions, policies mostly involve specifying server origins and script endpoints. This helps guard against cross-site scripting attacks (XSS).

the following policy for this website:
nginx configuration:

```
add_header Content-Security-Policy "default-src 'none'; script-src 'self' 'unsafe-inline'; connect-src 'self'; img-src 'self'; style-src 'self' 'unsa    fe-inline'; font-src 'self'; form-action 'none'; frame-src https://www.youtube.com; frame-ancestors 'none'"; base-uri 'none';
```

# Referrer-Policy

The [Referrer Policy](https://infosec.mozilla.org/guidelines/web_security#referrer-policy) tells the browser when it should
send the [Referer](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer) request header to other sites. This
tells the other site the the person visiting that site has just come from your site. You can improve privacy by telling
the browser not to do this.


nginx configuration:

```
add_header Referrer-Policy "no-referrer";
```

- [Content Security Policy (CSP) ](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)

# X-Content-Type-Options

The [X-Content-Type-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options) response header can
be used to tell the browser to opt out of [MIME sniffing](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types#MIME_sniffing),
a technique that is unnecessary if content types are configured properly.

nginx configuration:

```
add_header X-Content-Type-Options "nosniff";
```

# Tools

- [Mozilla Observatory](https://observatory.mozilla.org) - scan your web site and get a security rating with feedback on what you can do to improve.

# References

- [Mozilla Web Security Guidelines](https://infosec.mozilla.org/guidelines/web_security)
- [nginx add_header directive](https://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header)
