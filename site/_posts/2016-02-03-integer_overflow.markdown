---
layout: post
title: "Integer Overflows"
mathjax: true
---
The behavior of integer overflow for arithmetic operations varies across languages and, in the case of C,
between C compilers.

# Go

Unsigned n-bit integer arithmetic is modulo $$2^n$$. Signed n-bit integer arithmetic, if I'm reading this right, means
you do the arithmetic as you would if you weren't limited to n-bits and then chop off the part that doesn't fit into n-bits.

From [Integer overflow](https://golang.org/ref/spec#Integer_overflow):

> For unsigned integer values, the operations +, -, *, and &lt;&lt; are computed modulo $$2^n$$, where $$n$$ is the bit width of the unsigned integer's type. Loosely speaking, these unsigned integer operations discard high bits upon overflow, and programs may rely on "wrap around".
> 
> For signed integers, the operations +, -, *, and &lt;&lt; may legally overflow and the resulting value exists and is deterministically defined by the signed integer representation, the operation, and its operands. No exception is raised as a result of overflow. A compiler may not optimize code under the assumption that overflow does not occur. For instance, it may not assume that $$x < x + 1$$ is always true.

# C
The [C spec](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf) defines unsigned n-bit integer arithmetic modulo $$2^n$$.
However, signed integer arithmetic is left up to the implementation. Also note that C allows implementations to use one of three
integer representations: two's complement, one's complement, or sign and magnitude (6.2.6.2 Integer types).

§6.2.5 *Types*:

> The range of nonnegative values of a signed integer type is a subrange of the corresponding unsigned integer type, and the representation of the same value in each type is the same. A computation involving unsigned operands can never overflow, because a result that cannot be represented by the resulting unsigned integer type is reduced modulo the number that is one greater than the largest value that can be represented by the resulting type.

Annex H: Language independent arithmetic: H.2.2 Integer types:

> The signed C integer types int, long int, long long int, and the corresponding unsigned types are compatible with LIA−1 (language-independent arithmetic). If an implementation adds support for the LIA−1 exceptional values "integer_overflow" and "undefined", then those types are LIA−1 conformant types. C's unsigned integer types are "modulo" in the LIA−1 sense in that overflows or out-of-bounds results silently wrap. An implementation that defines signed integer types as also being modulo need not detect integer overflow, in which case, only integer divide-by-zero need be detected.

# Java

Java does not have unsigned integers. From an [interview](http://www.gotw.ca/publications/c_family_interview.htm) with the
[father of Java](https://en.wikipedia.org/wiki/James_Gosling):

> Gosling: For me as a language designer, which I don't really count myself as these days, what "simple" really ended up meaning was could I expect J. Random Developer to hold the spec in his head. That definition says that, for instance, Java isn't -- and in fact a lot of these languages end up with a lot of corner cases, things that nobody really understands. Quiz any C developer about unsigned, and pretty soon you discover that almost no C developers actually understand what goes on with unsigned, what unsigned arithmetic is. Things like that made C complex. The language part of Java is, I think, pretty simple. The libraries you have to look up.

OK, so you can kiss unsigned n-bit arithmetic modulo $$2^n$$ goodbye because Gosling thinks it's too hard for you to understand. Fortunately,
you can still learn the rules of signed arithmetic.

§15.17.1 Multiplication Operator *:

> If an integer multiplication overflows, then the result is the low-order bits of the
> mathematical product as represented in some sufficiently large two's-complement
> format. As a result, if overflow occurs, then the sign of the result may not be the
> same as the sign of the mathematical product of the two operand values.

§15.18.2 *Additive Operators (+ and -) for Numeric Types*:

> If an integer addition overflows, then the result is the low-order bits of the
> mathematical sum as represented in some sufficiently large two's-complement
> format. If overflow occurs, then the sign of the result is not the same as the sign of
> the mathematical sum of the two operand values.

# Summary
In C and Go, you get unsigned n-bit integer arithmetic modulo $$2^n$$, which makes
[finite field arithmetic](https://en.wikipedia.org/wiki/Finite_field_arithmetic) easy, assuming
your values all fit into n-bit integers (otherwise use an [arbitrary precision arithmetic](https://en.wikipedia.org/wiki/Arbitrary-precision_arithmetic)
library).

The behavior of signed integers is language specific and, in the case of C, toolchain specific as well.

### References
* [ISO C Working Group](http://www.open-std.org/JTC1/SC22/WG14/)
* [ISO/IEC 9899:TC3](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)
* [The Go Programming Language Specification](https://golang.org/ref/spec)
* [The Java Language Specification: Java SE 8 Edition: 2015-02-13](https://docs.oracle.com/javase/specs/jls/se8/jls8.pdf)
