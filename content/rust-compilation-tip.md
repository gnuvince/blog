+++
title = "A Simple Tip to Improve Rust Program Speed"
date = "2017-09-06T18:05:36-04:00"
+++
I am on vacation this week, so I decided to dig out a backtracking [Sudoku solver](https://github.com/gnuvince/sudoku-rs) I wrote last summer and see what I could do to improve its performance.  A couple of changes to the data structures and the algorithm yieled an important speed-up.  Previously, I had used a `BTreeSet` to store the list of candidates for a cell; I now use a `u32` to represent a set of 9 elements.  I used to compute the list of neighbors of a cell everytime it was needed; I now pre-compute the matrix of neighbors and avoid the unnecessary re-computations.  With these changes, solving 1000 normal-difficulty problems went down from 33 seconds to 1.5 second; the time to solve 1000 very hard problems went down from 15 minutes to 40 seconds.

I wondered if there was a way that I could improve the performance of my code further.  I looked for places in the code where I could avoid vector indexing---and in doing so, avoid Rust's bounds checking---but I didn't really feel like changing the way the whole program worked.  Somewhat randomly, I stumbled on a [forum thread](https://users.rust-lang.org/t/what-is-the-implementation-of-count-ones/4923) about the implementation of `count_ones()` (popcount), and buried in the detailed answer of *sorear* is a command-line option to have `rustc` select the CPU that LLVM should target.  By compiling my solver for my particular CPU platform (Intel Skylake), the time to solve the normal problems went down to 0.8 second and the time to solve the very hard problems went down to 20 seconds.  Nearly a 2x speed-up by adding an extra flag, not a bad deal!

You can pass flags to `rustc` from Cargo by using the `rustc` sub-command and giving your extra arguments after a double-dash.

    $ cargo build --release
       Compiling sudoku v0.1.0 (file:///home/vfoley/prog/rust/sudoku)
        Finished release [optimized + debuginfo] target(s) in 1.66 secs

    $ time ./target/release/sudoku <very_hard.txt >/dev/null
    real    0m36.542s
    user    0m36.530s
    sys     0m0.008s

    $ cargo rustc --release -- -C target-cpu=skylake
       Compiling sudoku v0.1.0 (file:///home/vfoley/prog/rust/sudoku)
        Finished release [optimized + debuginfo] target(s) in 1.65 secs

    $ time ./target/release/sudoku <very_hard.txt >/dev/null
    real    0m17.473s
    user    0m17.466s
    sys     0m0.004s

Update: [*est31* on Reddit](https://www.reddit.com/r/rust/comments/6ynm53/a_simple_tip_to_improve_rust_program_speed/dmosgt8/) mentions that we can replace `skylake` with `native` to let the backend figure out the appropriate value.

Update 2: [*Manisheart* on Reddit](https://www.reddit.com/r/rust/comments/6ynm53/a_simple_tip_to_improve_rust_program_speed/dmox7ks/) notes that it is better to use the `RUSTFLAGS="-C target-cpu=native"` environment variable instead of the `rustc` subcommand as it will apply the native compilation to all dependencies and not just the top crate.
