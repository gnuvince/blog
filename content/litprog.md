+++
date = "2017-01-29T14:51:42-05:00"
title = "A month of literate programming"

+++

During the month of December, a few colleagues and myself challenged ourselves to complete all the problems from [Avent of Code 2016](http://adventofcode.com/2016/).  I am proud to say that I raised to the challenge, and was able to get all the gold stars, 50 in total.  I'd been interested in [literate programming](http://www.literateprogramming.com/) for a little while, and as part of the month's challenge, I decided that I would write my solutions in LP; I used Norman Ramsey's [noweb](https://www.cs.tufts.edu/~nr/noweb/) tool and combined it with the [Rust](https://www.rust-lang.org/) programming language.

You can find my solutions on Github.

# What is literate programming?

Literate programming is this idea proposed by Don Knuth that we should write programs for other people to read.  To achieve this goal, the author composes a document using two languages: a typesetting language (e.g., LaTeX or Markdown) and a programming langage (e.g., C, Rust, or Python).   The document contains text that explains the big ideas, the small technical details, the data structures, the algorithms, the invariants, etc. that the reader must know about to understand the program; it also contains the *entire* code for the program.  The code for the program may be broken up in small *chunks*, and these chunks can appear in any order.

The *weaver* is a small program responsible for creating a nice, readable document (e.g., PDF or web page); the output of this program is what someone will want to read.  The *tangler* is a program that extracts all the code chunks from the document and assembles them into a source file, before handing that off to the compiler.

The most important part of writing a literate program, however, is not the tools, but the mindset of the author.  Rather than writing commands for the computer to execute, the author must become an educator and a narrator; his role is to guide the reader by making sure that the different parts of the program are introduced in a logical order (even if that order is contrary to what a compiler would accept).

# Observations of literate programming

I had written only one literate program before, so the Advent of Code was a great way for me to learn more about LP, and to identify its strengths and its weaknesses.

## Strengths

The greatest strength of LP is that, if it is done well, a reader can easily understand a program in its entirety.  The what's, the why's, the how's are all answered, and presented in a logical fashion.  Think of the last time you jumped into a large code base: where do you start reading?  Maybe in `main()`, maybe with the data structures?  And when you start to know where things are, you'll likely see code that makes you wonder "why did they do this like that?"  LP is an answer to that detective work: you start at page 1, and anytime something unusual is done, the author will have mentioned it.

## Weaknesses

LP is not without its flaws however.  One thing that I noticed was that writing a literate program was harder than writing a program AND writing its documentation.  It is difficult to find the right words to explain how a piece of code works; and it is even more difficult to do it for all the code in the program.  A few times during AoC, I was solving a problem late in the evening, and I felt too tired to provide a good narrative, and just punted by saying "I'm tired and cranky, I won't explain this."

Another weakness of literate programming is in the tooling: the tools you typically use become unavailable to you, because you are not writing a program, you are writing a document.  I write Rust and LaTeX in Emacs, and usually I have syntax highlighting, automatic indentation, code naviation, and code completion.  Getting multiple major modes to work in Emacs is almost impossible, so I had to write all my programs in fundamental-mode.  Given the small size of the programs, it wasn't too much of a problem, but I can imagine that in a larger program this would quickly become problematic.  Another difficulty is in compiler messages: the line numbers I was given (because rustc doesn't have an equivalent to the `#line` directive in gcc) were never correct, because they referred to the lines in the tangler's output rather than in the file I was actually editing.
