---
layout: post
title: "Cryptography Engineering Solution for Exercise 3.7"
---
Exercise 3.7 from [Cryptography Engineering](https://www.schneier.com/books/cryptography_engineering/):

> Describe an example system that uses DES but is insecure because of the DES complementation property.
> Specifically, describe the system, and then present an attack against that system; the attack should
> utilize the DES complementation property.

### Complementation Property of DES
The complementation property of DES says that $$\overline{E_k(x)}=E_\overline k(\overline x)$$,
where $$E_k(x)$$ is the value of $$x$$ DES encrypted with key $$k$$.

### Example System
A multi-user file system where each file is DES encrypted with a single key, $$k$$.

### Attack
The attacker sends two 64-bit blocks to be written to the file system, $$b$$ and $$\overline b$$. The file system
writes out two encrypted blocks to physical storage, $$E_k(b)$$ and $$E_k(\overline b)$$.

For each
key candidate $$x$$, compute $$E_x(\overline b)$$. This is a single cryptographic operation.
If the value is equal to $$E_k(\overline b)$$, then $$x=k$$ (i.e., the key was found).

Otherwise, compute the complement of the previous crypgraphic operation, namely $$\overline {E_x(\overline b)}$$,
which by the complementation property is $$ E_\overline x(b) $$. If $$ E_\overline x(b)=E_k(b) $$, then
$$\overline x=k$$ (i.e., the key was found).

The attack is thus able to check 2 key candidates for each cryptographic operation, reducing the attack
on the $$2^{56}$$ possible DES keys in half to $$2^{55}$$.

### References
The main idea for this answer is taken from fgrieu [answer](https://crypto.stackexchange.com/a/5493/25342)
on [Cryptography Stack Exchange](https://crypto.stackexchange.com/).

