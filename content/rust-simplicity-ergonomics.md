+++
date = "2019-05-11T07:06:47-04:00"
title = "Rust and the values of simplicity and ergonomics"
+++

<!--
MAIN POINTS:

    - Software as a reflection of value
    - Some clear values of Rust: Performance, Safety, Productivity
    - In tension: ergonomics and simplicity
    - Winner: ergonomics
    - Examples:
        - method calls
        - match ergonomics
        - ? operator
    - async: lots of talk about a little syntax, people who value simplicity disappointed

-->
If you've not seen Bryan Cantrill talk about [software as a reflection of values](https://www.youtube.com/watch?v=2wZ1pCpJUIM), let me give you the gist.
He argues that there are many desirable values that we can demand in our software (e.g., performance, reliability, approachability).
These values, though they are all desirable, are in tension: we can't have them all at the same time.
He also argues that *for some people*, some of these values are more important than others and the software they write is a reflection of those core values; these core values are pursued at the expense of other values.

In the video above, Cantrill gives C as an example: the core values of C are performance, simplicity, interoperability, and portability.
He gives another example, OpenBSD, and how it has just one core value: security.
Now, it's not that the authors of C did not value, say, readability, or that the OpenBSD developers do not value performance -- there are no "bad" values.
But when values are in tension and a decision needs to be made, the core values will always win (if they didn't they wouldn't be core values).
As an example, he points out that [OpenBSD disabled hyper-threading](https://www.theregister.co.uk/2018/06/20/openbsd_disables_intels_hyperthreading/), because it was insecure: their core value of security won over the value of performance.

What I've come to really appreciate from Cantrill's thesis is that it offers a way to understand why we are sometimes bothered by some technical decisions, yet cannot offer a strong
technical counter-point.
When that happens, it's typically because our own core values are in conflict with the values of the software we use.

If you head over to the [Rust](https://www.rust-lang.org/) website, you'll see in big bold letters the words Performance, Reliability, and Productivity.
A number of new Rust features in recent years have put those three core values above simplicity, for example:

- match ergonomics
- the `?` operator
- non-lexical lifetimes
- async IO

In all these cases, the language was made less simple, but in none of these degraded performance, reliability, or productivity.
Many people, including some of my colleagues, are unhappy with these features and try to find technical reasons for why they are bad.
But the technical arguments don't hold very well.
So the argument against them is typically one of values (even if the person doing the arguing does not realize it).
They go against the value of simplicity, and that ticks off the people for whom simplicity is more important than productivity.
(Or even, for those who argue that simplicity is necessary for productivity.)
