+++
title = "Reflecting on ppbert"
date = "2018-02-09T19:06:08-05:00"
draft = false
+++

I had an itch: I was pretty-printing the [BERT-encoded](http://erlang.org/doc/apps/erts/erl_ext_dist.html) terms that we use in a production system at work and it was *very* slow.  The Erlang shell took more than two minutes to dump the largest file.  (It took about 0.1 second to read and parse the file; the rest was spent in `io:format`.)  I decided to scratch that itch: I wrote [ppbert](https://github.com/gnuvince/ppbert), a command-line utility that reads BERT-encoded values and pretty-prints them.  I've worked sporadically on ppbert for almost a year now, I use it daily at work, I'm happy with it, and I want to write about some of the things I learned during that journey.

I wanted ppbert to be a good Unix tool.  It was essential that it can read from stdin, write to stdout, and thus can be inserted in a Unix pipeline.  (I'm astounded---and annoyed---when programs *can't* be used in a pipe.)  The interface of ppbert should be familiar to Unix users: it reads from stdin, from files, or from a mix of both with `-` acting as the filename for stdin; normal output goes to stdout, diagnostics and errors go to stderr; the format of warnings and errors follows the typical Unix style (`ppbert: reason for error`); the return code is 0 on success and 1 on failure; ppbert has a manpage.  The main "failure" of ppbert as a Unix tool is that it consumes a whole input file before it starts pretty-printing it (a bit like `sort(1)`).

I wrote ppbert in Rust because I like the language and because I wanted to use it.  But if you'd like to hear technical reasons why choosing Rust made sense, here are a few.  First, I wanted something that would be faster than Erlang and it would've been counter-productive to reach for Python or Ruby; Rust compiles to native code, uses LLVM to apply thousands of optimizations, and many benchmarks shows that the performance of Rust programs is [right up there with C and C++](https://benchmarksgame.alioth.debian.org/u64q/which-programs-are-fastest.html).  Rust's type system and ownership/borrowing systems are also right up my alley: I suck at programming, I make mistakes with strings and memory in C all the time, and the Rust bondage helps me write better software.  Rust has a very good story for third-party libraries: cargo is an absolute joy to use, and the selection of quality libraries on [crates.io](https://crates.io) is growing quickly (more about good libraries later).  I tried to limit the number of dependencies in ppbert---for example, I don't use serde to pretty-print JSON---, but I like that complex functionality is a single line in Cargo.toml away.  Finally, the Rust compiler produces statically-linked executable, which makes it easier to use ppbert on remote servers that don't have development tools installed: I just transfer the executable with `scp`.

I'm happy that I chose Rust: I had a faster pretty-printer the first time that I compiled an executable and with some further tweaks, I was able to improve the speed to a level that I'm happy with.  Today, I can pretty-print the large BERT file in 3 seconds rather than 2 minutes.  I got some of the extra performance gains by applying lessons that one can learn from any language: buffering your output---the `File` struct in Rust doesn't buffer by default; finding ways to do less work in the common cases---in ppbert I got a satisfying speed boost by avoiding UTF-8 validation when all the bytes of an atom's name where in the ASCII range.  I also got some speed boosts by reaching for some of Rust's unsafe functions, for example by using the `.get_unchecked()` Vec method when the bound checks had already been performed.  I found that using `perf` with Rust is underwhelming; it could tell me in which functions ppbert spent most of its time, but I had to divine the reasons.

I'm quite happy with the third-party crates that I use.  I started using nom, a parser combinator library, but I found that using its macros was unnatural and injecting my own errors was awkward, so I stopped using it and wrote my own parser instead.  (This was with nom 2; I have not tried the newer nom 3.)  For command-line arguments parsing, I like clap: it's easy to add new options, and easy to consume them.  Rayon blew me away!  I used it in ppbert's sibling program, bert-convert, and simply by using `.par_iter()` rather than `.iter()`, I made the conversion of all our production .bert files to .bert2 twice as fast.  The crates num and encoding, which I use for bigints and latin-1 support respectively, were easy to use and because they do their jobs without problems, I haven't needed to look at that code in a long time.

Some people lament the state of Rust's tooling, particularly IDE support.  I'm a simple man: I like [some syntax highlighting](http://vfoley.xyz/syntax-highlighting/), automatic indentation, jump-to-definition, and auto-completion.  Emacs, rust-mode, and racer-mode gave me all that.

One issue I ran into with Rust itself was how the `println!()` macro behaves in a pipeline: if a pipe is closed early while printing a long string, println panics.  The code below exhibits the behaviour in a simple program.

```
/tmp$ cat sample.rs
fn main() {
    let mut buf = String::new();
    for _ in 0 .. 65536 {
        buf.push_str("foo\n")
    }
    println!("{}", buf);
}

/tmp$ rustc -O sample.rs

/tmp$ ./sample | head -n 1
foo
thread 'main' panicked at 'failed printing to stdout: Broken pipe (os error 32)', /checkout/src/libstd/io/stdio.rs:690:8
note: Run with `RUST_BACKTRACE=1` for a backtrace.

```

There is an easy fix, and that's to use the `writeln!()` macro and to ignore errors.

```
/tmp$ cat sample.rs
use std::io::{self, Write};

fn main() {
    let mut buf = String::new();
    for _ in 0 .. 65536 {
        buf.push_str("foo\n")
    }
    let _ = writeln!(io::stdout(), "{}", buf);
}

/tmp$ rustc -O sample.rs

/tmp$ ./sample | head -n 1
foo
```

It's something to be wary of if you write Unix utilities in Rust.

Ppbert is not a popular program---I'm probably its only user---because BERT is not a very popular format.  Still, I'm happy with the work I did, I'm happy that I scratched that itch, and I'm happy that ppbert has been a good vehicle for learning about Rust, improving performance, and creating good Unix programs.
