+++
date = "2018-05-27T12:06:13-04:00"
title = "What's next for ppbert?"
draft = false
+++
ppbert has improved since the [last time](https://vfoley.xyz/ppbert/) I wrote about it:

- I've done more work to improve the speed of pretty-printing; the large .bert file that took 3 seconds to process in Februrary now takes 1.5 seconds.
- I've added binary artifacts to releases — binaries for *ppbert* and *bert-convert* that are statically-linked against musl.  You should be able to download these and run them on any 64-bit Linux system.  (I inspired myself heavily from the work of my former co-worker, [Sevag](https://github.com/sevagh/pq).)
- I've added support for a new type of file, Erlang's internal [disk_log](http://erlang.org/doc/man/disk_log.html) format.

The next feature of ppbert that I have in mind might be the most ambitious yet: support for pretty-printing Erlang records.  In Erlang, a record is stored as a tuple: the first element is the name of the record, and the remaining elements are the values of the fields.  Consider the `person` record below.

```
-record(person, {
    name,
    gender,
    age
}).

#person{name="Obama", gender=male, age=56} = {person, "Obama", male, 56}.
```

The record expression (`#person{ ... }`) and the tuple expression (`{person, ...}`) are equivalent.  When `term_to_binary/1` converts a record, it returns a binary for a tuple.

ppbert can parse and pretty-print tuples, so it can handle records without any problem.  However, it would be useful for users to see their records with the field names, rather than the tuple representation.  To support this, I will add a new command-line option to ppbert to read the record declarations in a .erl or .hrl file.

```
ppbert --record-definitions my_module.erl --record-definitions my_include.hrl ...
```

One guiding principle for this feature is to never require the user to re-create their record declarations.  I want users to point to their existing Erlang files and have ppbert do the hard work.  To support this feature, I will need to write a scanner and parser for Erlang.  The fields of a record declaration have three parts:

1. The name of the field (required);
2. The default value of the field (optional);
3. The type of the field (optional).

Here is a more complex definition of the `person` record from above:

```
-record(person, {
    name                                 :: string(),
    gender = undefined                   :: undefined | male | female,
    age    = floor(100 * rand:uniform()) :: pos_integer()
}).
```

The default value of a field can be an arbitrary expression (though there are a few limitations), and that's why I think I need a complete parser.  I can't think of a way to get the name of a record's fields with just a scanner.

This feature will require a lot of time and effort, but I think it'll be worth it and should make ppbert an even more useful tool for Erlang programmers.
