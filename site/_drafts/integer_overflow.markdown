---
layout: post
title: "Integer Overflows"
---

# Go
Unsigned n-bit integer arithmetic is is modulo $$2^n$$.
From [Integer overflow](https://golang.org/ref/spec#Integer_overflow):

> For unsigned integer values, the operations +, -, *, and &lt;&lt; are computed modulo $$2^n$$, where $$n$$ is the bit width of the unsigned integer's type. Loosely speaking, these unsigned integer operations discard high bits upon overflow, and programs may rely on "wrap around".
> 
> For signed integers, the operations +, -, *, and &lt;&lt; may legally overflow and the resulting value exists and is deterministically defined by the signed integer representation, the operation, and its operands. No exception is raised as a result of overflow. A compiler may not optimize code under the assumption that overflow does not occur. For instance, it may not assume that $$x < x + 1$$ is always true.

# C
The [C language spec](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf) defines unsigned n-bit integer arithmetic modulo $$2^n$$. From Section *6.2.5 Types*:

> The range of nonnegative values of a signed integer type is a subrange of the corresponding unsigned integer type, and the representation of the same value in each type is the same. A computation involving unsigned operands can never overflow, because a result that cannot be represented by the resulting unsigned integer type is reduced modulo the number that is one greater than the largest value that can be represented by the resulting type.

However, signed integer arithmetic is left up to the implementation. From *Annex H: Language independent arithmetic: H.2.2 Integer types*:

> The signed C integer types int, long int, long long int, and the corresponding unsigned types are compatible with LIA−1 (language-independent arithmetic). If an implementation adds support for the LIA−1 exceptional values "integer_overflow" and "undefined", then those types are LIA−1 conformant types. C's unsigned integer types are "modulo" in the LIA−1 sense in that overflows or out-of-bounds results silently wrap. An implementation that defines signed integer types as also being modulo need not detect integer overflow, in which case, only integer divide-by-zero need be detected.

### References
* [The Go Programming Language Specification](https://golang.org/ref/spec)
* [ISO C Working Group](http://www.open-std.org/JTC1/SC22/WG14/)
* [ISO/IEC 9899:TC3](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)
