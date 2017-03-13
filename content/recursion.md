+++
title = "Understanding Recursion"
date = "2017-03-11T22:46:44-05:00"
draft = false
+++

Recursion is my absolute favorite programming technique.
It's powerful, it's elegant, and for many problems it yields simple and beautiful solutions.
Unfortunately, recursion has a terrible reputation: new programmers find it hard and unnatural and some programmers with years of experience avoid it because of the trauma it incurred when they learned it.
There are valid, practical reasons to not use recursion; fear and disdain are not good reasons.

## Don't go down the rabbit hole

To understand a recursive function, many programmers try to visualize the chain of calls and returns.
The intent is laudable, but this approach inevitably leads to failure.
Humans can only hold 7±2 things in their heads ([Miller's Law](https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two)); to properly work out the mechanics of a recursive function, we'd have to remember the values of the local variables in every invocation, where recursive calls are made, etc.
Very quickly, our brains would get overloaded, we wouldn't know where we are or where we came from, and we'd be no closer to understanding the function.

The right way to write and understand recursive code is to assume that the function invocations return the right results, and to forget about the mechanics of recursion.
It's easier, faster, and we already do it all the time.
When we invoke `f` in `main`, do we think about the stack frame of `f`?
No!  We rely on the name and/or documentation of the function to know what it does, we use its result, and we move on to the next thing.
Why complicate our lives when we see a call to `f` inside `f`?
The function call mechanism is the same,  we can just use the result of the function and be on our way.

The following Python function computes the depth of a tree, i.e., the maximum length between the root node and a leaf node.

```python
def depth(tree):
    if tree is None:
        return 0
    else:
        d_left = depth(tree.left)
        d_right = depth(tree.right)
        return 1 + max(d_left, d_right)
```

This is a well-formed recursive function: it has a base case, an inductive case, and the recursive calls are made on "smaller" inputs, i.e., they are getting closer to the base case.
When the tree is empty (base case), we return zero.
When the tree is not empty (inductive case), we compute the depths of the left and right sub-trees, we take the greatest of those two values, and we add one.
That's it!  We understand this function and we haven't given one iota of thought to stack frames.

## The recipe

**Base case:**
To write a recursive function, we first need to find the base cases.
Most often there is only one, but there may be more.
Typical base cases are: zero, the empty string, the empty list, the empty tree, `null`, etc.
If the input to the function is the base case, we return the answer and we're done.

**Inductive case:**
After we've handled the base cases, it's time to tackle all the other cases.
This is where we do recursive calls.
The argument of a recursive call needs to be "smaller"---"closer" to the base case than the current argument.
If the function accepts an integer and the base case is zero, the typical argument to the recursive call is `n-1`; if the function accepts a tree, the typical argument is a sub-tree.
The idea is that eventually a recursive call will hit the base case.
Once you have the result for a smaller input, find how to use it to compute the result of the current input, return it, and you're done.
