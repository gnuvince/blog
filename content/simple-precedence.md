+++
date = "2024-02-04"
title = "Simple Precedence"
+++

[A discussion](https://youtu.be/fIPO4G42wYE) between Jonathan Blow and Casey Muratori on the handling of precedence in Jon's compiler recently popped in my YouTube feed.
The discussion is three hours long and focuses on implementing operator precedence more easily and more simply in Jai using [Pratt parsing](https://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/).
Jon and Casey also talk about the previous implementation of operator precedence in Jai which used tree-rewriting and the classic approach which organizes the different precedence levels into different production rules.

My favorite approach to operator precedence is the one used in APL, J, and K: [get rid of it](https://code.kx.com/q4m3/4_Operators/#41-operator-precedence).
Array languages are known for their symbol-heavy programs, but something rarely mentioned is that in languages with so many esoteric operators, the rules for reading those operators are the simplest and most straight-forward of all:

1. All operators have the same precedence, no exception.
2. All operators associate to the right, no exception.

With these two rules, it's easy to understand a complex expression: we read right-to-left. Take the following snippet of code (written completely randomly):

```
5 | 1 << 3 & 3 | 1 << 4
```

In a language like Python or C, do you know what this expression evalutes to without running it or referring to the documentation?
In a language with only the two precedence rules above, it's very easy:

- `1 << 4 = 16`
- `3 | 16 = 19`
- `3 & 19 = 3`
- `1 << 3 = 8`
- `5 | 8 = 13`

Having only two simple rules makes it easy for readers of programs to understand complex expressions.
The simple rules also make the life of the language implementors easier: instead of deciding whether to use Pratt Parsing or multi-leveled productions, and deciding on whether `<<` should have a higher or lower precedence than `&`, the parsing of operators becomes something that doesn't require a three hour discussion.

The one thing that is lost by going for this radically simpler operator precedence is familiarity.
We've had PEDMAS drilled into our skulls since junior high; remembering PEDMAS is extremely important for those quizzes on Twitter claming that "only 1% of the population gets this question right".
But if we are willing to give up familiarity for a little while—I say for a little while, because eventually the no-precedence approach becomes second nature—we can have a language that's simpler to understand and simpler to implement.

Unfortunately, this kind of radical simplicity is rarely seen because programmers don't value simplicity very much and don't mind the extra complexity of things like precedence rules—they even _like_ extra, unnecessary complexity.
But that'll be the subject of another post...
