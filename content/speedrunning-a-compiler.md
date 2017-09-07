+++
title = "Speedrunning a Compiler"
date = "2017-08-07T20:00:00-04:00"
draft = false
+++

At AdGear, the developers typically end their week at "Friday Not
Friday", a team activity from 4pm to 5pm.  One person gives a
presentation on any technical subject while the others listen and sip
a beer to wind down before the week-end.

Last week, I gave a demonstration that I called "Speedrunning a
Compiler".  I wanted to show my colleagues the basics of writing a
compiler, and I thought it would be more instructive if they saw code
rather than an abstract flowchart.  Thus, I wrote a compiler for a
very small language that I call "Minilang".  We went over the classic
phases of a compiler: scanner, parser, typechecker, and code
generator.  I used Python as my implementation language; the code I
wrote was not pretty and abused Python's flexibility (mutation galore,
dynamic typing, using strings and dicts instead of objects) and I
generated MIPS assembly.

The resulting program is available on Github:
https://github.com/gnuvince/fnf-vfoley/blob/master/compiler/compiler.py

I wrote the scanner and parser by hand partly because Minilang is
simple enough, but mostly because I wanted the process of transforming
text into an AST to not be mysterious and hidden behind tools like
flex and bison (or an equivalent in Python, like PLY).  Similarly,
rather than generating C or JavaScript code, I used assembly because
it seems more "real": had I generated C, the question of how the code
becomes executable would've been hidden by gcc or clang.  Generating
assembly code makes the mapping between high-level concepts and
low-level constructs more explicit.  Also, by generating very naïve
assembly---I basically implemented a stack machine---I could show
patterns of code that a simple peephole optimizer should recognize and
replace.

Thanks to a couple practice runs during the week and some copy-pasting
from my completed example, I was able to finish in about 50 minutes
and hopefully to enlighten my colleagues a little bit.
