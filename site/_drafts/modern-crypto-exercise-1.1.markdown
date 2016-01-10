---
layout: post
title: "Introduction to Modern Cryptography: Exercise 1.1"
---
Exercise 1.1 from [Introduction to Modern Cryptography, 2nd Edition](https://www.cs.umd.edu/~jkatz/imc.html):

> Decrypt the ciphertext provided at the end of the section on mono-alphabetic substitution ciphers.

    JGRMQOYGHMVBJWRWQFPWHGFFDQGFPFZRKBEEBJIZQQOCIBZKLFAFGQVFZFWWE
    OGWOPFGFHWOLPHLRLOLFDMFGQWBLWBWQOLKFWBYLBLYLFSFLJGRMQBOLWJVFP
    FWQVHQWFFPQOQVFPQOCFPOGFWFJIGFQVHLHLROQVFGWJVFPFOLFHGQVQVFILE
    OGQILHQFQGIQVVOSFAFGBWQVHQWIJVWJVFPFWHGFIWIHZZRQGBABHZQOCGFHX

### Background
The [mono-alphabetic substitution cipher](https://en.wikipedia.org/wiki/Substitution_cipher)
maps a plaintext, whose elements are from a set of of $$n$$ symbols
to a ciphertext, whose elements are also from a set of $$n$$ symbols. Assuming our plaintext can contain the 26 lowercase
characters in the English language, and the ciphertext the 26 uppercase characters, encryption can
be implemented using the [tr command](https://en.wikipedia.org/wiki/Tr_(Unix)) as follows:

    tr abcdefghijklmnopqrstuvwxyz $KEY < plaintext

and decryption:

    tr $KEY abcdefghijklmnopqrstuvwxyz < ciphertext

where `$KEY` 26 character key that is a permuation of the 26 uppercase English characters
(e.g., *ABCDEFGHIJKLMNOPQRSTUVWXYZ*, *BXZDEQGHIJKLMNOFRSVCYWTUPA*, etc).

There are $$26!$$ possible keys. However, the text describes
an attack on the cipher that makes use of the known frequency of characters in
the English language to narrow the key to a smaller number of probable keys. It then goes on to say:

> It should not be surprising that the mono-alphabetic substitution cipher can be quickly
> broken, since puzzles based on this cipher appear in newspapers (and are solved by some
> people before their morning coffee!). We recommend that you try to decipher the following
> ciphertext---this should convince you how easy the attack is to carry out.

Unfortunately, I was not able to solve it before my morning coffee. Nor next morning's coffee.
Or the next... well you get the picture. It was harder than the text made it seems. Especially since I didn't...

### Read the Errata
The text provides an incorrect table of English letter frequencies. I discovered this after
a few days of working on the problem (ahhhhhhhh!). The issue is documented in the [errata](https://www.cs.umd.edu/~jkatz/imc/errata-2nd.pdf).
I have a [corrected frequency table on github](https://github.com/drichardson/crypto_exercises/blob/master/intro-modern-crypto/1.1/english_text_stats.txt).

### The Attack
Once I had the correct English language frequency table, I also made use of the [tools I developed](https://github.com/drichardson/crypto_exercises/tree/master/intro-modern-crypto/1.1)
for the problem and also a list of [2 character frequencies](http://www.math.cornell.edu/~mec/2003-2004/cryptography/subs/digraphs.html) to help me
narrow in on the key.

**Step 1** Produce a frequency table of the ciphertext characters, sorted by count. Put this next
to the english text frequency table sorted by frequency:

    e   12.7    F   37
    t   9.1 Q   26
    a   8.2 W   21
    o   7.5 G   19
    i   7.0 L   17
    n   6.7 O   16
    s   6.3 V   15
    h   6.1 H   14
    r   6.0 B   12
    d   4.3 P   10
    l   4.0 J   9
    u   2.8 I   9
    c   2.8 Z   7
    w   2.4 R   7
    m   2.4 M   4
    f   2.2 E   4
    y   2.0 Y   3
    g   2.0 K   3
    p   1.9 C   3
    b   1.5 A   3
    v   1.0 S   2
    k   0.8 D   2
    x   0.2 X   1
    j   0.2
    z   0.1
    q   0.1

Some of the plaintext characters (j, z, and q) don't have corresponding ciphertext entries. That indicates that the cipher
text didn't use the full set of 26 characters.

**Step 2** Build a probable key by sorting the table from step 1 by english plaintext letter, and then by selecting columns 1 (the plaintext
column) and column 3 (the ciphertext column). This can also be produced using the `most_probable_key.sh` script in my github repo:

    ./most_probable_key.sh < ciphertext
    abcdefghijklmnopqrstuvwxyz
    WAZPFEKHL?DJMOGC?BVQISRXY?

Where the 3 ?s stand for the 3 characters unused by the ciphertext in question.

### References
* [Digraph Frequency](http://www.math.cornell.edu/~mec/2003-2004/cryptography/subs/digraphs.html)
* [Tools](https://github.com/drichardson/crypto_exercises/tree/master/intro-modern-crypto/1.1) I made to help me solve the problem.
