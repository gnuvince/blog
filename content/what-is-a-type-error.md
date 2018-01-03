+++
title = "What is a Type Error?"
date = "2017-09-13T17:09:48-04:00"
draft = false
+++
[The top comment](https://www.reddit.com/r/programming/comments/6zmgn7/static_vs_dynamic_languages_a_literature_review/dmwo1pl/) by /u/staticassert in a Reddit thread on type systems makes an interesting point, one that I made in the past myself: what is a type error?

I read those types (pun intended) of threads often enough, and one recurring argument often made by people who doubt the benefits of type systems goes like this: "I rarely make errors that the type checker would catch; my bugs are logic in nature."  The problem with this statement---and this is staticassert's point---is that it's not clear what constitutes a type error.

Consider the following scenario: reading one line from a text file when the file is opened in write-only mode.  Is this a type error or not?  Let's look at what Python thinks.

```
with open("/etc/passwd", "w") as f:
    line = f.readline()
    print("[{0}]".format(line))

```

When we run this program, we obtain the following error at run-time:

```
Traceback (most recent call last):
  File "ty.py", line 1, in <module>
    with open("/etc/passwd", "w") as f:
IOError: [Errno 13] Permission denied: '/etc/passwd'
```

Python has a `TypeError` exception, but this is not the one raised here, so clearly this is a logic error, not a type error---or is it?  Here is the equivalent code in OCaml:

```
let () =
  let f = open_out "/etc/passwd" in
  let line = input_line f in
  Printf.printf "[%s]\n" line
```

When we try to *compile* this code, we get the following type error at compile-time:

```
File "ty.ml", line 3, characters 24-25:
Error: This expression has type out_channel
       but an expression was expected of type in_channel
```

So which is it, is reading from a write-only file descriptor a type error or not?  I think the best answer to this question is "reading from a write-only descriptor *can be made* into a type error."  At the level of the OS, reading from a file descriptor requires the number of a descriptor, a buffer, and a length.  If something goes wrong, such as reading from a write-only descriptor, an error will be generated.  Though that's the reality of the OS, it doesn't have to be the interface that a language presents to its users.

Here is another example: it's a common error to add numbers of different unit types, e.g., adding feet and meters without a proper conversion.  In F# the `float` type can be parameterized by a unit of measure (e.g., `float<meter>` vs. `float<foot>`) and an attempt to add two values of different type will cause a compilation error.  If we ask the question "is adding values of different units a type error or not?", the answer, like in the previous paragraph, is "adding values of different units *can be made* into a type error."

Discussions on type systems would be more interesting if rather than discussing subjective topics without hard data (e.g., productivity, ease-of-use) we instead looked at how an error of logic can be made into a type error and whether the cost of doing this is low enough that we'd want to do it.
