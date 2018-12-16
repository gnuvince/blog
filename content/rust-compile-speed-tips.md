+++
title = "How to alleviate the pain of Rust compile times"
date = "2018-08-11T07:10:12-04:00"
draft = false
+++
A few days ago, I wrote about two [Rust pain points](https://vfoley.xyz/rust-at-work/) when using Rust at work.  One of these points were the long compile times.  In this post, I want to share a few tips that can help alleviate that pain.

## Use `cargo check`

We typically use the compiler for two reasons: to verify if the syntax and/or types are correct and to generate a runnable program.  When compiling a program, especially a release build, the majority of the time is spent generating LLVM bytecode and optimizing that bytecode.  If you only want to know whether your 3-line change typechecks, you don't want to wait for the optimizer.

For this reason, Cargo has a subcommand called `check` that only invokes the front-end.  It completes faster than a debug build and much faster than a release build.

As an example, here are the timing results of `cargo check` and `cargo build` for my personal project, ppbert.  (The benchmarks are performed by [hyperfine](https://github.com/sharkdp/hyperfine/).)

```
Benchmark #1: cargo clean && cargo check

  Time (mean ± σ):      8.131 s ±  0.424 s    [User: 24.234 s, System: 1.245 s]

  Range (min … max):    7.529 s …  8.845 s

Benchmark #2: cargo clean && cargo build

  Time (mean ± σ):     16.904 s ±  0.794 s    [User: 52.009 s, System: 2.240 s]

  Range (min … max):   15.728 s … 18.098 s

Benchmark #3: cargo clean && cargo build --release

  Time (mean ± σ):     48.454 s ±  2.540 s    [User: 145.644 s, System: 3.205 s]

  Range (min … max):   46.229 s … 54.107 s

Summary

  'cargo clean && cargo check' ran
    2.08x faster than 'cargo clean && cargo build'
    5.96x faster than 'cargo clean && cargo build --release'
```

From a clean slate, `cargo check` is 2x faster than `cargo build` and 6x faster than `cargo build --release`.  During development, when you just want to check that what you wrote is correct, definitely reach for `cargo check`.

## Use `sccache`

A co-worker introduced me to [`sccache`](https://github.com/mozilla/sccache/), a compilation caching service by Mozilla that is compatible with Rust.  It will cache the build artifacts that Cargo generates, so if you `cargo clean` your project or go to work on a second project that shares dependencies with the first one, you won't have to rebuild everything.

You can install `sccache` with Cargo: `cargo install sccache`.  To activate `sccache`, add the following line to your `.bashrc`:

```
export RUSTC_WRAPPER=sccache
```

And here are the time differences.

```
Benchmark #1: cargo clean && cargo build

  Time (mean ± σ):     15.726 s ±  0.330 s    [User: 50.183 s, System: 2.210 s]

  Range (min … max):   15.148 s … 16.210 s

Benchmark #2: cargo clean && RUSTC_WRAPPER=sccache cargo build

  Time (mean ± σ):      6.877 s ±  4.665 s    [User: 6.964 s, System: 0.916 s]

  Range (min … max):    5.135 s … 20.136 s

  Warning: The first benchmarking run for this command was
  significantly slower than the rest (20.136 s). This could be caused
  by (filesystem) caches that were not filled until after the first
  run. You should consider using the '--warmup' option to fill those
  caches before the actual benchmark. Alternatively, use the
  '--prepare' option to clear the caches before each timing run.

Summary

  'cargo clean && RUSTC_WRAPPER=sccache cargo build' ran
    2.29x faster than 'cargo clean && cargo build'
```

Given the ease of installing and configuring `sccache`, I see no reason not to use it and get that 2x speed boost.  One downside of `sccache`: it won't make your continuous integration builds faster.  (You could configure `sccache` to use an S3 bucket, but I prefer to have completely clean builds from my CI.)

## Avoid LTO

LTO is the acronym for link-time optimization.  Compilers build and optimize compilation units individually.  LTO is a mechanism for taking those individually-optimized object files and finding more opportunities for optimization when they are considered as a group.  This is great if you want to have the fastest possible program, but the price you pay are higher compilation times.  In Rust, the compilation unit is the crate; if the heavy computations are all done in your crate, then maybe LTO isn't necessary.

Here is the difference in execution time of ppbert with and without LTO on a 100 MiB .bert2 file.

```
Benchmark #1: /tmp/ppbert-without-lto -2 /tmp/100m.bert2

  Time (mean ± σ):      1.926 s ±  0.005 s    [User: 1.308 s, System: 0.618 s]

  Range (min … max):    1.921 s …  1.937 s

Benchmark #2: /tmp/ppbert-with-lto -2 /tmp/100m.bert2

  Time (mean ± σ):      1.887 s ±  0.012 s    [User: 1.273 s, System: 0.613 s]

  Range (min … max):    1.867 s …  1.905 s

Summary

  '/tmp/ppbert-with-lto -2 /tmp/100m.bert2' ran
    1.02x faster than '/tmp/ppbert-without-lto -2 /tmp/100m.bert2'
```

There is a slight difference (which is why I enable LTO), but let's look at what LTO does to compile times (with sccache enabled):

```
Benchmark #1: sed -i "s/lto.*/lto=false/" Cargo.toml && cargo clean && cargo build --release

  Time (mean ± σ):      5.793 s ±  0.075 s    [User: 11.390 s, System: 0.767 s]

  Range (min … max):    5.693 s …  5.901 s

Benchmark #2: sed -i "s/lto.*/lto=true/" Cargo.toml && cargo clean && cargo build --release

  Time (mean ± σ):     18.483 s ±  0.321 s    [User: 34.288 s, System: 1.182 s]

  Range (min … max):   17.971 s … 18.893 s

Summary

  'sed -i "s/lto.*/lto=false/" Cargo.toml && cargo clean && cargo build --release' ran
    3.19x faster than 'sed -i "s/lto.*/lto=true/" Cargo.toml && cargo clean && cargo build --release'
```

LTO makes the compilation of ppbert 300% longer for a 2% speed gain at run-time.  If you have a project that you find too long to build, I encourage you to measure the compile times with and without LTO, and the execution speed with and without LTO.  Maybe you'll find (like I did in a project at work) that you don't want to enable LTO.


## Control your dependencies

Rust has a rich ecosystem, and every day we have access to more quality crates.  This is mostly a blessing, but more crates mean more compilation, and this has a negative effect on your compile times.  Now, don't shun all dependencies and write everything yourself!  Rather, make sure that the crates your bring in pay for themselves.

One thing that you can do to control dependencies is to examine your depdendencies and see if they have features that you can disable.  For instance, in ppbert I use [clap](https://clap.rs) to parse command-line arguments; by default, clap colors its output and offers suggestions when the user makes a spelling mistake.  Some people like these features, but I'm not a fan myself.  Fortuately, the authors of clap have made such features optional.  So I am able to deactivate what I don't need, and not pay the compilation price for it.

Here's the dependency tree of clap with default-features enabled, and without.

```
$ rg default-features Cargo.toml && cargo tree -p clap
33:default-features=true
clap v2.31.2
├── ansi_term v0.11.0
├── atty v0.2.11
│   └── libc v0.2.42
├── bitflags v1.0.3
├── strsim v0.7.0
├── textwrap v0.9.0
│   └── unicode-width v0.1.5
├── unicode-width v0.1.5 (*)
└── vec_map v0.8.1

$ vi Cargo.toml

$ rg default-features Cargo.toml && cargo tree -p clap
33:default-features=false
clap v2.31.2
├── bitflags v1.0.3
├── textwrap v0.9.0
│   └── unicode-width v0.1.5
└── unicode-width v0.1.5 (*)

```

So I only need to compile 4 external crates rather than 9.  Many crates make some of their dependencies optional; make sure you only bring in what you really need.

## Conclusion

Rust doesn't have the fastest compiler in the world, and that creates friction when writing code.  I'm looking forward to improvements on that front more than any other Rust feature.  Fortunately, in the mean time, there are ways to make Rust compile your projects a little faster.
