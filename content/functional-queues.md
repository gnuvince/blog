+++
date = "2017-04-13T20:18:25-04:00"
title = "Functional Queues"
draft = false
+++
[First-in first-out queues](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)) are a data structure used in many algorithms (including my favorite one---breadth-first search) and as a building block for complex functionality, the operations on queues should be as efficient as possible.  This can be a bit of a challenge in a functional language: the bread-and-butter data structure of functional programming, the list, supports fast insertion and deletion at the head---ideal for enqueuing or dequeuing respectively---but operations at the other end of the list take O(n) time in the length of the list.  Must we give up on our aspirations of purity and use mutable cells?

Thankfully, a simple and elegant solution to this problem exists.  By using *two lists*---one for enqueuing items and one for dequeuing them---we can use the fast cons operation to push elements into one list and use pattern matching to pop them out of the other.  If we try to dequeue an element when the pop list is empty and the push list isn't, we reverse the push list, move the elements into the pop list, and continue.

Let's see how we can implement this data type.  We will use the OCaml language and we'll start with a signature definition, i.e., the interface that our data type will have to support.

```
module type QUEUE = sig
  type 'a t
  val empty    : 'a t
  val is_empty : 'a t -> bool
  val enqueue  : 'a -> 'a t -> 'a t
  val dequeue  : 'a t -> ('a option * 'a t)
end
```

If you aren't familiar with OCaml's module system, this declaration says that `QUEUE` is a module signature.  A module implements this signature if it defines a type `'a t` (`t` is the name, `'a` is a type parameter; in Java it would be written as `T<A>`) and the functions `empty`, `is_empty`, `enqueue`, and `dequeue`.  A user will manipulate our queue module through this interface and will never be aware of its implementation.

We can then define a module called `Queue` (it's common in OCaml, but not required, to use all caps to write the signature name and use Pascal-case for the implementation name).

```
module Queue : QUEUE = struct
  type 'a t = ('a list * 'a list)

  let empty = ([], [])

  let is_empty = function
    | ([], []) -> true
    | (_, _)   -> false

  let enqueue x (pop, push) =
    (pop, x :: push)

  let rec dequeue = function
    | ([], [])      -> (None, empty)
    | (x::xs, push) -> (Some x, (xs, push))
    | ([], push)    -> dequeue (List.rev push, [])
end
```

The type `'a t` is a tuple of two lists of `'a`.  We create an empty queue by returning a tuple containing two empty lists and we verify that a queue is empty by pattern matching on the tuple and asserting that the two elements are the empty list.  Both operations take constant time.

To enqueue an element, we use the cons operator (`::`) to add it to the front of the push list.  This is also a constant time operation.

The `dequeue` function is the most interesting, and where the "magic" happens.  If the pop list and the push list are empty, there are no elements to dequeue and we return `None`.  If the pop list has an element in its pop list, we remove it from the list and return it.  When only the push queue has elements, we reverse them (to make sure the least recent is at the head), make that the new pop queue and invoke dequeue again.

Now, this last operation appears to be O(n), but suppose we have *n* calls to `enqueue` followed by *n* calls to `dequeue`; the first dequeue takes time proportional to *n* (the list reversal), but all subsequent dequeues take constant time.  This makes the operation O(1) amortised which is why it is acceptable in many applications.

And there you have it, a purely functional FIFO queue!  For more purely functional data structures, please check out [Purely Functional Data Structures](https://www.amazon.com/Purely-Functional-Structures-Chris-Okasaki/dp/0521663504) by Chris Okasaki.
