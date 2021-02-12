---
layout: post
title: "Introduction to Modern Cryptography: Exercise 1.1"
mathjax: true
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
for the problem and also a list of [2 character frequencies](http://pi.math.cornell.edu/~mec/2003-2004/cryptography/subs/digraphs.html) to help me
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

Some of the characters (j, z, and q) don't have corresponding ciphertext entries. That indicates the plaintext
that generated the ciphertext was also missing 3 letters (the most probable missing letters being j, z, and q).


**Step 2** Build a probable key by sorting the table from step 1 by english plaintext letter, and then by selecting columns 1 (the plaintext
column) and column 3 (the ciphertext column). This can also be produced using
[`most_probable_key.sh`](https://github.com/drichardson/crypto_exercises/blob/master/intro-modern-crypto/1.1/most_probable_key.sh):

    ./most_probable_key.sh < ciphertext
    abcdefghijklmnopqrstuvwxyz
    WAZPFEKHL?DJMOGC?BVQISRXY?

Where the 3 *?*s stand for the 3 characters that don't appear in the ciphertext.

**Step 3: Ciphertext Decrypt 1** Decrypt the ciphertext with the most probable key generated in the previous step.

    tr 'WAZPFEKHL?DJMOGC?BVQISRXY?' abcdefghijklmnopqrstuvwxyz < ciphertext    
    lowmtnyohmsrlawatedahoeektoedecwgrffrlucttnpurcgiebeotseceaaf
    noandeoehanidhiwiniekmeotariaratnigearyiriyieveilowmtrnialsed
    eatshtaeedtntsedtnpednoeaeluoetshihiwntseoalsedeniehotstseuif
    notuihtetoutssnvebeoratshtaulsalsedeahoeuauhccwtorbrhctnpoehx

If you're some sort of savant, perhaps you can pattern recognize that in your head, but I got nowhere with it.

**Step 4: Digraph Frequencies** According to [this digraph frequency table](http://pi.math.cornell.edu/~mec/2003-2004/cryptography/subs/digraphs.html),
the 10 most common digraphs in English are:

|--------------------
| Digraph | Frequency
|-|-
| th | 1.52
| he | 1.28
| in | 0.94
| er | 0.94
| an | 0.82
| re | 0.68
| nd | 0.63
| at | 0.59
| on | 0.57
|===================

Using the [`pattern_frequency.go`](https://github.com/drichardson/crypto_exercises/blob/master/tools/pattern_frequency.go) tool, I
built a table of the top 10 ciphertext digraphs:

	tr -d '\n' < ciphertext | \
		go run pattern_frequency.go -length 2 | \
		sort -k2 -nr | head -n 10
	QV	9
    FP	8
    VF	7
    GF	7
    QO	6
    PF	5
    OL	5
    FW	5
    FG	5
    WQ	4

At this point, I started at the top of both tables and then filled out the rest. For example, $$th=QV$$ implies $$at=?V$$.

Iteration 1, assume $$QV=th$$:

|--------------------
| Plaintext | Frequency | Ciphertext
|-|-|-
| th | 1.52 | QV
| he | 1.28 | V?
| in | 0.94 | ??
| er | 0.94 | ??
| an | 0.82 | ??
| re | 0.68 | ??
| nd | 0.63 | ??
| at | 0.59 | ?V
| on | 0.57 | ??
|===================

Iteration 2, assume $$F=e$$. This wasn't a guess; the probable key generator suggested this relationship.

|--------------------
| Plaintext | Frequency | Ciphertext
|-|-|-
| th | 1.52 | QV
| he | 1.28 | VF
| in | 0.94 | ??
| er | 0.94 | F?
| an | 0.82 | ??
| re | 0.68 | ?F
| nd | 0.63 | ??
| at | 0.59 | ?V
| on | 0.57 | ??
|===================

Iteration 3, assume $$P=r$$. I choose this because I need *er* and *re* and have *PF* and *FP*:

|--------------------
| Plaintext | Frequency | Ciphertext
|-|-|-
| th | 1.52 | QV
| he | 1.28 | VF
| in | 0.94 | ??
| er | 0.94 | FP
| an | 0.82 | ??
| re | 0.68 | PF
| nd | 0.63 | ??
| at | 0.59 | ?V
| on | 0.57 | ??
|===================


Iteration 5, one digraph on my ciphertext list is *QO*. I've already assumed the $$Q=t$$, and the most common English
digraph on the full table (not the top 10 I'm using here) shows the most second most common digraph beginning with a *t* (after *th*)
is *to*, so I'll make $$O=o$$.

|--------------------
| Plaintext | Frequency | Ciphertext
|-|-|-
| th | 1.52 | QV
| he | 1.28 | VF
| in | 0.94 | ??
| er | 0.94 | FP
| an | 0.82 | ??
| re | 0.68 | PF
| nd | 0.63 | ??
| at | 0.59 | ?V
| on | 0.57 | O?
| to | 0.52 | QO
|===================



**Step 5: Decrypt 2**. Try decrypting with the probable key, modified with the digraph analysis:

	tr 'WAZBFEKVL?DJMGOC?PHQISRXY?' abcdefghijklmnopqrstuvwxyz < ciphertext
	lnwmtoynsmhdlawaterasneektnerecwgdffdlucttopudcgiebentheceaaf
	onaorenesaoirsiwioiekmentadiadatoigeadyidiyieveilnwmtdoialher
	eathstaeertothertoperoneaelunethsisiwothenalhereoiesnththeuif
	ontuistetnuthhovebendathstaulhalhereasneuausccwtndbdsctopnesx

*the* appear 4 times. Might be on the right track.

**Step 6: Iterate on longer words.** Use `pattern_frequency.go` to look for patterns in ciphertext that appear
multiple times. This process is automated for patterns 2--10 characters in length in
[`analyze.sh`](https://github.com/drichardson/crypto_exercises/blob/master/intro-modern-crypto/1.1/analyze.sh).
Iterating on this output is a bit easier than the raw ciphertext, because its easier to see separation
between words:

First try:

	./analyze.sh ciphertext| tr 'WAZBFEKVL?DJMGOC?PHQISRXY?' abcdefghijklmnopqrstuvwxyz
    at	4
    en	5
    ea	5
    oi	5
    re	5
    to	6
    ne	7
    he	7
    er	8
    th	9
    hst	2
    asn	2
    ath	2
    lhe	3
    top	3
    ths	3
    alh	3
    ere	4
    the	4
    her	4
    nwmt	2
    lnwm	2
    othe	2
    thst	2
    ....

*thst* is probably *that*, so swap *a* and *s* in the key. *oi* isn't common, and we're already pretty sure about *o*
being in the right place, and *on* is high on the frequency list so switch *i* and *n*.

    ./analyze.sh ciphertext| tr 'HAZBFEKVG?DJMLOC?PWQISRXY?' abcdefghijklmnopqrstuvwxyz
    st	4
    ei	5
    es	5
    on	5
    re	5
    to	6
    ie	7
    he	7
    er	8
    th	9
    hat	2
    sai	2
    sth	2
    lhe	3
    top	3
    tha	3
    slh	3
    ere	4
    the	4
    her	4
	...

**Decrypt 3**. 

    tr 'HAZBFEKVG?DJMLOC?PWQISRXY?' abcdefghijklmnopqrstuvwxyz < ciphertext
    liwmtoyiamhdlswstersaieektierecwgdffdlucttopudcgnebeithecessf
    oisoreieasonranwnonekmeitsdnsdstongesdyndnynevenliwmtdonslher
    esthatseertothertoperoieseluiethananwotheislhereoneaiththeunf
    oitunatetiuthhovebeidsthatsulhslheresaieusuaccwtidbdactopieax

Not sure if this is forward or backward progress, but I now notice a couple things that
look like words: *unfoitunate* and *ieason*. Both would benefit from swapping *r* and *i*.


    tr 'HAZBFEKVP?DJMLOC?GWQISRXY?' abcdefghijklmnopqrstuvwxyz < ciphertext
    lrwmtoyramhdlswsteisareektreiecwgdffdlucttopudcgneberthecessf
    orsoiereasonianwnonekmertsdnsdstongesdyndnynevenlrwmtdonslhei
    esthatseeitotheitopeioreselurethananwotherslheieonearththeunf
    ortunatetruthhoveberdsthatsulhslheiesareusuaccwtrdbdactopreax

Breaking up by eyeball and we can see lots of words now.

    lrwmtoyramhdlswsteisareektreiecwgdffdlucttopudcgneberthecess for
    soie reason ianwnonekmertsdnsdstongesdyndnyn even lrwmtdonslhei
    es that seei to the itopeioreselure than anwother slheie on earth the unf
    ortunate truth hoveberds that sulhslheies are usuaccwtrdbdactopreax

*for soie reason* is probably *for some reason*, so swap *i* and *m*. *are usuaccw* could be *are usually* so try
swapping *c* for *l* and *w* for *y*.

    tr 'HAJBFEKVM?DZPLOC?GWQISYXR?' abcdefghijklmnopqrstuvwxyz < ciphertext
    cryitowraihdcsystemsareektremelygdffdculttopudlgneberthelessf
    orsomereasonmanynonekiertsdnsdstongesdwndnwnevencryitdonschem
    esthatseemtothemtopemoresecurethananyotherschemeonearththeunf
    ortunatetruthhoveberdsthatsuchschemesareusuallytrdbdaltopreax

Breaking up again:

    cryitowraihdc systems are ektremely gdffdcult to pudlgneber theless for
    some reason many none kiertsdnsdstongesdwndnwn even cry it don schemes
    that seem to them to pe more secure than any other scheme on earth the
    unfortunate truth hoveberds that such schemes are usually trdbdaltopreax

*ektremely gdffdcult* looks like *extremely difficult*, so swap *k* for *x*, *d* for *g*, and *i* for *d*.
*to pe more* looks like *to be more*, so swap *p* for *b*.

    tr 'HCJKFEMVB?XZPLOA?GWQISYDR?' abcdefghijklmnopqrstuvwxyz < ciphertext
    crygtowraghicsystemsareextremelydifficulttobuildneperthelessf
    orsomereasonmanynonexgertsinsistondesiwninwnevencrygtionschem
    esthatseemtothemtobemoresecurethananyotherschemeonearththeunf
    ortunatetruthhoveperisthatsuchschemesareusuallytripialtobreak

Breaking it up:

    crygtowraghic systems are extremely difficult to build nepertheless for
    some reason many non exgerts insist on desiwninwnev encrygtion schemes
    that seem to them to be more secure than any other scheme on earth the
	unfortunate truth hoveper is that such schemes are usually tripial to break

OK, almost done now. *nepertheless* is *nevertheless*, so swap *p* for *v*. *crygtowraghic*
is *cryptographic*, so swap *g* for *p* and *w* for *g*.

    tr 'HCJKFEYVB?XZPLOM?GWQIASDR?' abcdefghijklmnopqrstuvwxyz < ciphertext
    cryptographicsystemsareextremelydifficulttobuildneverthelessf
    orsomereasonmanynonexpertsinsistondesigningnewencryptionschem
    esthatseemtothemtobemoresecurethananyotherschemeonearththeunf
    ortunatetruthhoweveristhatsuchschemesareusuallytrivialtobreak

Broken up:

    cryptographic systems are extremely difficult to build nevertheless
	for some reason many non experts insist on designing new encryption
	schemes that seem to them to be more secure than any other scheme on earth
	the unfortunate truth however is that such schemes are usually trivial to break

Tada!

### References
* [Digraph Frequency](http://pi.math.cornell.edu/~mec/2003-2004/cryptography/subs/digraphs.html)
* [Probablem Specific Tools](https://github.com/drichardson/crypto_exercises/tree/master/intro-modern-crypto/1.1)
* [More Generic Tools](https://github.com/drichardson/crypto_exercises/tree/master/tools)
