+++
date = "2018-11-30T22:14:06-05:00"
title = "vi, my favorite config-less editor"
+++

<!--
MAIN POINTS:

    - used to be a vi user
    - don't need a config file: super convenient when connecting to a remote
      server at work or shelling into a docker image.
    - I use vi and Emacs very differently: Emacs acts as the central piece of my
      workflow, vi is but one tool in my workflow.
    - I'm not super interested in having functionality inside vi (see :he
      design-not of vim and neovim); I'd prefer when outside tools invoke vi
      (alpine, git, etc.)
-->

Before I became an Emacs user, I was a vi user,
and though Emacs is my primary editor, I still use vi daily.
I use vi for quickly skimming the content of a file and quick edits to configuration files;
I use vi when I'm on a remote server or when a command-line utility invokes `$EDITOR`.
The main reason why I still use vi is because I'm able to use it very efficiently even without a configuration file.

I learned vi circa 2001 from a magazine and from vimtutor.
It was my primary text editor until 2007 or 2008 when I switched to Emacs.
Back then, I had a rather long `.vimrc`, complete with configurations for Linux and Windows, GTK vim and curses vim, and I used a few plugins such as bufexplorer.vim.

Recently, I deleted my old `.vimrc` and started a new one from scratch.
I no longer use plugins and I don't use a GUI version of vim.
For these reasons, I now consider myself more a vi user than a vim user.
(I am however a big fan of text objects, and I want unlimited undo, so using `nvi` is not something I would consider.)
My `.vimrc` is now only 12 lines and most of these changes are conservative and uncontroversial:
backspace works "normally" in insert mode all the time, I enable incremental search, I use 4 spaces for indentations rather than hard tabs, I activate syntax highlighting.
Even though vim offers a myriad of settings, a vanilla setup is extremely capable and usable.

I find that being able to use an editor without custom configuration is extremely useful.
Here are a couple of examples:
I learned how to exploit Linux binaries from the book [Art of Exploitation](https://nostarch.com/hacking2.htm).
The book comes with a companion live CD that you can use to follow examples from the book and try to perform the hacks yourself.
Emacs is not installed in the live CD, but vim is, and I was perfectly happy and comfortable using it to read the source code of the examples and modify them.
Another example: recently at work, I wanted to write a Python script on a server that didn't have Python installed, but had Docker.
I launched a Python container, installed vim-tiny, and proceeded to write, debug, and improve my script without ever feeling that I was editing with a hand tied behind my back.

It is oddly satisfying to know that no matter the kind of machine I find myself on or the kind of restrictions it has (no network to download Emacs and/or my custom configuration, corporate policy against fetching packages from MELPA, etc.), that there will always be an editor that I can happily use without needing to make it "my own".

[Tim O'Reilly](https://web.archive.org/web/20060219132752/http://www.oreilly.com/pub/a/oreilly/ask_tim/1999/unix_editor.html)
and [Paul Graham](https://www.reddit.com/r/reddit.com/comments/21918/tim_oreilly_editor_vi_or_emacs/c2315/)
have also cited usability without configuration a reason for preferring vi to Emacs.

<i>Thanks to [Richard Kallos](http://www.rkallos.com/) for proof-reading an early version of this article.</i>
