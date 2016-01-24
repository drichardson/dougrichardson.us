---
layout: post
title: "Optimizing Memory Allocations in Go"
---
For certain types of programs, memory allocations can become a bottleneck, not just in terms of
using memory, but also in terms of CPU cycle spent managing memory. This article is intended
to expose someone already somewhat familiar with Go to 

In Go, there are a few things
to keep in mind.

#### The Stack
Some memory allocations are done on the [stack](https://en.wikipedia.org/wiki/Stack-based_memory_allocation).
Each goroutine has its own stack; thus, no locking has to be done.
Items can simply be pushed on the top of
the stack and popped of the top of the stack. Everything below the top of the
stack is allocated memory and everything above the top of the stack is unallocated memory.
Allocating more memory means increasing the top of the stack and deallocating means
decrementing the top of the stack. Thus allocations/deallocations are an increment/decrement
of an number tracking the top of the stack.

#### The Heap
Some memory allocations are put on the [heap](https://en.wikipedia.org/wiki/Memory_management#DYNAMIC).
Unlike the stack, the heap does not have a single partition of allocated and free regions.
Rather, there is a lists of free regions. Thus, a data structure must be used to keep track of
the free regions. When an item is allocated, it is removed from the free regions. When an item
is freed, it is added back to the list of free regions. Manipulating this data structure requires
synchronization (locking) between threads of execution (goroutines).

#### The Data Segment
Memory can also be allocated in the [data segment](https://en.wikipedia.org/wiki/Data_segment). This
is where global variables are stored. The data segement is defined at compile time and does not grow
and shrink as the program runs.

#### Stack or Heap?
[The Go Programming Language Specification](https://golang.org/ref/spec) does not define
which items will be allocated on the stack or which will be allocated on the heap. Unlike C, where
local variables are always stack allocated and malloc always allocates items on the heap, it is left 
to the Go implementation to determine where items will be allocated. Perhaps surprising to C++ programmers,
the [new builtin](https://golang.org/pkg/builtin/#new) does not define stack or heap based allocation (while in
C++ the default [new operator](http://en.cppreference.com/w/cpp/memory/new/operator_new) which allocates an
object from the heap).

[Escape analysis](https://en.wikipedia.org/wiki/Escape_analysis) is one method used to determine whether
an object is stack or heap allocated. It determines if an item created in a function (e.g., a local variable)
can escape out of that function or to other goroutines. For example, in the following function, x escapes.

    

#### Garbage Collector
Go uses [garbage collection](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)) 
for memory management. The Go garbage collector occasionally has
to [stop the world](https://en.wikipedia.org/wiki/Tracing_garbage_collection#Stop-the-world_vs._incremental_vs._concurrent) to complete it
collection task. Since [Go version 1.5](https://golang.org/doc/go1.5#gc), the collector is designed
so that the *stop the world* task will take no more than 10 milliseconds out of every 50
milliseconds of execution time, though usually it will take far less time than 10 milliseconds. For
the purposes of this article, keep in mind that the more items that are allocted means more for the
garbage collector to keep track of.

The garbage collector has to be aware of both heap and stack allocated items. This is easy to
see if you consider a heap allocated object *H*, only referenced by a stack allocated object *S*.
Clearly, the garbage collector cannot free *H* until *S* is freed and so the garbage collector
must be aware of stack allocated items.

## Rules of Thumb
Just by knowing a few properties of the stack, the heap, and the garbage collector we can formulate
a few simple rules of thumb.

1. Stack allocation/deallocation is $$O(1)$$.
2. Heap allocation/deallocation is $$O(g(n))$$,
where $$n$$ is the number of free blocks and $$g$$ is implementation dependent.[^1]
3. The garbage collector is $$O(n)$$, where $$n$$ is the number of items tracked by the collector.

### References
- [Golang Escape Analysis](http://blog.rocana.com/golang-escape-analysis)
- [Profiling Go Programs](https://blog.golang.org/profiling-go-programs)

#### Footnotes

[^1]:Perhaps $$g(n)=n$$ if the free list is a linked list or perhaps $$g(n)=n \cdot lg(n)$$ if the free list is a balanced binary search tree. Note, I have no experience building memory allocators, and I doubt either of these methods are used in production grade allocators, but the point is they aren't $$O(1)$$.


