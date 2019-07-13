+++
date = "2019-02-19T21:42:32-05:00"
title = "Feeling more confident with property-testing"
+++

<!--
MAIN POINTS:

    - simple problem (individual elements to ranges)
    - some corner cases
    - how to test so that I'm confident that the functions is correct?
-->

For one of my projects at work, I thought I could reduce memory usage
by storing vectors of sorted integers as vectors of ranges.  For
example, the vector `[1,3,4,5,10,14,15,16,17,18]` would be represented
by `[1, 3..5, 10, 14..18]`.

(Spoiler: the memory usage was higher because there weren't enough
runs of consecutive numbers to offset the cost of using 8 bytes rather
than 4 bytes for single numbers.)

I quickly wrote a Rust function to convert a slice of u32s to a vector of ranges.

```
type Range = (u32, u32);

/// Returns the shortest vector of ranges that covers `xs`.
///
/// The argument `xs` should (1) be sorted, (2) contain no dupes.
/// If `xs` respects (1) and (2), then the following invariant holds:
///     expand(&to_ranges(&xs)) == xs
pub fn to_ranges(xs: &[u32]) -> Vec<Range> {
    let mut v: Vec<Range> = Vec::new();

    if xs.is_empty() {
        return v;
    }

    let mut start_idx = 0;
    for idx in 1 .. xs.len() {
        if xs[idx] != xs[idx-1] + 1 {
            v.push( (xs[start_idx], xs[idx-1]) );
            start_idx = idx;
        }
    }
    v.push( (xs[start_idx], xs[xs.len() - 1]) );
    v.shrink_to_fit();
    return v;
}
```

Array indices can be hard to get right, and anything more complex than
a simple *for* loop and I start doubting myself and I wonder if
there's a subtlety I've gotten wrong.  My code seems to work, but I'm
afraid that it could blow up at the worst possible time.  I'm sure
it's a feeling shared by many programmers.

To give us more confidence, we write unit tests.  We prepare carefully
crafted inputs and we write down their expected outputs; we pass the
inputs to our function, and we ensure that our predicted outputs match
the actual outputs.  Here's a unit test for `to_ranges`:

```
#[test]
fn manual_tests() {
    assert!(to_ranges(&[]).is_empty());
    assert_eq!(vec![(1,1), (3,3), (5,5)], to_ranges(&[1,3,5]));
    assert_eq!(vec![(1,4)], to_ranges(&[1,2,3,4]));
    assert_eq!(
        vec![(1,1), (3,5), (10,10), (14,18)],
        to_ranges(&[1,3,4,5,10,14,15,16,17,18]));
}
```

Is this sufficient?  I don't know.  All the tests pass, but there are
only 4, that's not very much.  Maybe there's a condition that's not
tested here?  Maybe I subconsciously avoided an edge case?  We wanted
to increase our confidence in our code, but we've only increased our
self-doubt!

Property testing is just another tool in the testing toolbox, but it's
one that can increase our confidence in our code.  Rather than test a
function in a case-by-case fashion, we instead write properties: we
express relationships that exist between **all** inputs and their
outputs.  We then let a generator feed hundreds, even thousands of
test cases to our function and verify that our properties hold.

The property for `to_ranges` is given in its doc-comment: if an acceptable
input—a slice of sorted u32s with no duplicates—is given, then we should
be able to "expand" the output and obtain the input again.  This is a common
pattern in property testing.

Using the [proptest](https://crates.io/crates/proptest) crate, I
create a simple property and I ask the proptest runner to generate
5000 inputs and ensure that the property hold.

```
use proptest::prelude::*;
use proptest::test_runner::Config;

pub fn expand(ranges: &[Range]) -> Vec<u32> {
    let mut v: Vec<u32> = Vec::new();
    for (start, end) in ranges {
        v.extend(*start ..= *end);
    }
    return v;
}

proptest! {
    #![proptest_config(Config::with_cases(5000))]
    #[test]
    fn prop_to_ranges(bset in prop::collection::btree_set(any::<u32>(), 0 .. 1000)) {
        let input: Vec<u32> = bset.into_iter().collect();
        let output: Vec<u32> = expand(&to_ranges(&input));
        prop_assert_eq!(&input[..], &output[..]);
    }
}
```

(I use the generator for `BTreeSet<u32>` to obtain a sorted set of
u32s and then convert to a `Vec<u32>`.  I think it's simpler than
generating a vector, sorting it, and de-duplicating it.)

With not very many lines of code, I'm able to greatly increase my confidence
that I didn't mess up the indexes in `to_ranges`.  It's still possible that
there's something wrong that my property test missed, but it would be much
less likely that a bug was present in code that was tested 5000 times than
in code that was tested 4 times.

Property tests are a great addition to your testing toolbox.  A recent
book by Fred Hébert, [Property-Based Testing with PropEr, Erlang, and
Elixir](https://pragprog.com/book/fhproper/property-based-testing-with-proper-erlang-and-elixir),
offers a great and approachable introduction to property testing using
tools for Erlang and Elixir.  Although the book is mostly targeted at
programmers of these two communities, there is enough
language-agnostic advice to make it a good purchase for anyone
interested in using property testing to make their programs more
robust.
