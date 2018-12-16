+++
title = "Rust at Work—Two Paint Points"
date = "2018-08-09T13:47:12-04:00"
draft = false
+++
The [2018 State of Rust Survey](https://blog.rust-lang.org/2018/08/08/survey.htm) asks the following question:

> How could we help make Rust more accepted at your company?

We use Rust in three projects at work, and the two primary concerns for people are (1) the crates ecosystem, and (2) compile times.  I gave some details in my answer to the survey, and I want to expand on those two points here.

The first pain point we have with Rust at work is the crates ecosystem.
We like Cargo and we like that it offers a first-class solution to managing dependencies and building a project.
However, it's difficult—especially for people who are new to Rust—to know which crates are good and which crates should be avoided.
We mostly have to rely on our past experience with different crates—I recommend clap, regex, and rayon, because I've had a good experience with them, but was I just lucky to avoid their bugs?
The number of downloads or the number of GitHub stars can give an indication of the popularity of a project, but it does not tell if the project has had a complete code review by a third party, if it's been fuzzed, if the authors are using it in production, etc.
It would be a great help to navigating the crates ecosystem if there were badges that projects could obtain when their versions have met levels of quality assurance that go beyond a unit test suite.

The other pain point of Rust that makes its adoption less attractive are the long compile times.
It's well known that compiling Rust code takes a long time, especially when using the `--release` flag for `cargo build`.
There are ways to make compilation faster (this will be the subject of an upcoming post) but the bottom line is that iterating in Rust is slower than in many other languages, including compiled languages like C or Java.

When he announced that he was working on a new programming language, Jonathan Blow said that he wanted to minimize friction in his language, i.e., the difficulty/effort going from an idea to an implementation.
I think Rust's compile times are one of its greatest source of friction.
The memory model of Rust—with lifetimes, shared borrows, mutable borrows, moves, etc.—is a steep curve when learning Rust, but eventually people form their own mental models, and can then write code quickly and safely.
Waiting on the compiler doesn't get shorter because you are more experienced with Rust.
I'm following with interest the [efforts](https://blog.mozilla.org/nnethercote/2018/04/30/how-to-speed-up-the-rust-compiler-in-2018/) to make `rustc` faster, and I hope that 2018 or 2019 will bring improvements on that front.

There is one point that no one at work disputes though: the Rust language is incredibly well-designed.
The fans of C and low-level imperative programming and the fans of Scala and high-level functional programming find that the Rust core team has made judicious choices in creating a safe, modern, and fast language.
