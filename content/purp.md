+++
date = "2018-12-12T20:02:15-05:00"
title = "purp, an Emacs theme of few colors"
+++
A few years ago, [I asked on Reddit](https://www.reddit.com/r/emacs/comments/3oc7jk/nice_emacs_themes_with_a_limited_number_of_colors/) whether anyone had recommendations for a theme that used only a few colors.  I found that too many colors---what many refer to as a Christmas tree---was not helping me understand code better, but in fact was distracting me.  I also thought that turning off syntax highlighting entirely was too radical a solution.  I wanted a theme that would just highlight a few, well-chosen elements.  Unfortunately, most of the minimal themes that I found were monochrome, which is not what I was looking for.

So I began working on a [theme of few colors](https://vfoley.xyz/syntax-highlighting/) that I've been using and tweaking for a while now.  I've finally decided to make it available on [Github](https://github.com/gnuvince/purp) and publish it to [MELPA](https://melpa.org/#/purp-theme).  You can install purp by invoking the command `M-x package-install RET purp-theme`.  A light version called `purp-light` is also included in the package.

I have not gone and modified the color of every face in every mode, just the ones that I encountered daily in my work.  In programming modes, you'll see the following colors:

- Purple for function definitions
- Green for comments
- Orange for string literals
- Yellow on red for dangerous stuff (e.g., the `unsafe` keyword in Rust)
- White (or black) for everything else

The colors for function definitions and comments makes them easy to find and the color for strings helps to spot an un-escaped double quote.

I hope you like purp, there's a lot of work left to be done, including how to not have it activate as soon as it's installed, which is a really bad first impression.
