+++
date = "2022-10-31"
title = "You already know how to parse by hand"
+++

An article was published in /r/rust a couple weeks ago, [Parsing With Nom](https://naiveai.hashnode.dev/practical-parsing-nom), a blog post explaining how to use nom to create a parser for a data format in the BitTorrent protocol called Bencode.
Nom is a Rust library that provides _parser combinators_, small functions that provide simple parsing capabilities and which can be combined together to form functions that can parse more complex input.

The article praises nom for being an easy way to write parsers for people who don't have a CS degree and who haven't dedicated the time and effort needed to read the 200 pages of parsing material in the Dragon Book.
That characterization of parsing saddened me; parsers are super useful, they should be part of every programmer's toolbox, and it's a shame that their reputation as being hard discourages programmers from learning to write them.
It's especially sad, since writing a parser requires only basic programming concepts: functions, loops, ifs, arrays, structs, and recursion.

Parsing _appears_ difficult because there are indeed 200 pages of dense theoretical concepts in the Dragon Book.
Academics don't make it appear any easier: to sound authoritative and learned, they use technical terms, like LR(1), LL(k), ε-closures, start sets, shift-reduce conflicts, etc. further reinforcing the impression that parsing is a complex matter better left to people who have the proper training.

Fortunately, most of what a working programmer who wants to convert text to an in-memory data structure is learned in _Programming for Dummies_.
To support this claim, I will demonstrate writing a parser for the Bencode format—the same one as in the nom article—using only programming constructs that you are already familiar with.
By the end of this article, you will find that there is nothing especially hard, technical, or scary about writing parsers and you'll know how to create one yourself.

## The data types

A parser needs two main pieces of information: the data to be parsed (bytes or tokens) and the position of the current piece of data to be analyzed.
For Bencode, I start with a struct containing two fields: a vector of bytes and an index in that vector.
If more data needed to be tracked, such as line numbers, column numbers, list of errors, etc., the `Parser` struct would be a good place to store them, but for this simple parser, we won't bother with other information.

<aside>
Bencode is simple enough that we can go straight from the raw bytes to an in-memory representation.
For more complex languages, such as JSON or Go, we'd have a _tokenization_ phase that turns chunks of bytes into tokens to make the parsing phase easier.
Tokenization works almost exactly like parsing, except that recursion is disallowed.
</aside>

```
pub struct Parser {
    buf: Vec<u8>,
    pos: usize,
}

impl Parser {
    pub fn new(buf: Vec<u8>) -> Parser {
        Parser { buf, pos: 0 }
    }
}
```

We also need a data structure that will be returned by the parsing methods.
In the literature, this is called an abstract syntax tree—an AST.
In Rust, it's typical to use an enum to represent an AST.

```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum BValue {
    Int(i64),
    Str(String),
    List(Vec<BValue>),
    Dict(Vec<(String, BValue)>),
}
```

Notice how our AST has cases for each of the Bencode value types: integers, strings, lists, and dictionaries.
That's typical: we want the AST to closely mirror specification.

Finally, we need a type for reporting errors.
Since this is a simple parser, we'll use `String` as our error type.
A more involved parser would likely use an enum to explicitly list the different kinds of parsing errors that can occur.

```
type Error = String;
```

## Utility methods

Next, we add a few utility methods to our parser.
There are typically two kinds of methods in a parser: parsing methods which know how to parse a small part of the language—we'll start writing those in the next section—and utility methods which are used by the parsing methods.
Here are the four utility methods we'll use.

- `peek()`: this returns the byte at `buf[pos]`; if `pos` is past the end of the buffer, we return the byte `0`. For some kinds of parsers, especially binary parsers, `0` could be a valid byte, and so another approach should be used to represent EOF—`Option<u8>` would be one such choice.
- `advance()`: this is like `peek()`, and it also moves `pos` forward by one.
- `expect(b)`: this method calls `advance()` and verifies that the byte `b` was consumed; if any other byte was seen, it returns an error.
- `eof()`: this returns true if all the input buffer has been consumed and false otherwise. It's not completely necessary since we can get the functionality with `peek() == 0`, but it makes the source code easier to read.

(A parser for a more complex language would have more utility methods, such as `skip_spaces()` or `report_error()` to avoid some tedium, but I'd expect to find our four methods in all parsers.)

```
impl Parser {
    fn peek(&self) -> u8 {
        if self.pos >= self.buf.len() {
            return 0;
        } else {
            return self.buf[self.pos];
        }
    }

    fn advance(&mut self) -> u8 {
        let b = self.peek();
        if b != 0 {
            self.pos += 1;
        }
        return b;
    }

    fn expect(&mut self, expected: u8) -> Result<(), Error> {
        let actual = self.advance();
        if actual != expected {
            return Err(format!(
                "syntax error: expected {:?}, found {:?}",
                expected as char, actual as char
            ));
        }
        return Ok(());
    }

    fn eof(&self) -> bool {
        return self.peek() == 0;
    }
}
```

And that's it, we have all the building blocks needed to write our parser.
The rest of the parser will be built on top of these utility methods and will use the programming constructs that you've been familiar with since you started programming.

## The parsing functions

### Predicting the kind of data to read

Our first parsing method guides the parsing process: it peeks the current byte in the input to decide how to proceed.
In parser jargon, this is called a _predictive parser_.
This is a simple and easy-to-understand strategy; it doesn't always work (what if we can't tell just from the next byte what to do?), but when it does we should use it.

```
impl Parser {
    fn parse_value(&mut self) -> Result<BValue, Error> {
        match self.peek() {
            b'i' => return self.parse_int(),
            b'l' => return self.parse_list(),
            b'd' => return self.parse_dict(),
            b'0'..=b'9' => return self.parse_str(),
            c => {
                return Err(format!("parse value: invalid initial byte {:?}", c as char));
            }
        }
    }
}
```

If the parser is currently looking at the letter `'i'`, we parse an integer and return its AST (or its error); if the parser is looking at a `'l'` or `'d'` we parse a list or a dictionary, respectively; if the next character is a digit, we parse a string; finally, if we see anything else, we report an error.

### Integers

Now that we have `parse_value` to guide the parsing, we need to fill in the other parsing methods.
The first one we'll tackle is `parse_int`.
In Bencode, integers look like this:

```
# General form
i<digits>e

# Examples
i0e    (0)
i-3e   (-3)
i999e  (999)
```

Our strategy for parsing will be:

- Read the leading `i`
- Read an optional `-`
- Read the digits, accumulating them into a value
- Read the trailing `e`
- Return the accumulated value

<aside>
<b>Exercise idea:</b> modify `parse_int` to reject negative zero and numbers with leading zeros.
</aside>

```
impl Parser {
    fn parse_int(&mut self) -> Result<BValue, Error> {
        self.expect(b'i')?;

        let mult: i64 = if self.peek() == b'-' {
            self.advance();
            -1
        } else {
            1
        };

        let start_pos = self.pos;
        let mut value: i64 = 0;
        while !self.eof() && self.peek().is_ascii_digit() {
            let b = self.advance();
            value = value * 10 + (b - b'0') as i64;
        }

        if self.pos == start_pos {
            return Err(String::from("invalid integers: no digits"));
        }

        self.expect(b'e')?;
        return Ok(BValue::Int(mult * value));
    }
}
```

I think it's pretty straight-forward; nothing that anyone would claim requires a CS degree or having read the Dragon Book.

- We expect to see the byte `'i'`; if we find anything else, we report an error;
- We peek for a minus sign; if it's there, we advance `pos` and set the multiplier to -1; otherwise we leave `pos` where it is and set the multiplier to 1;
- We advance over the digits until we reach EOF or peek a byte that's not an ascii digit; we accumulate the digits in a `i64` value;
- After we exit the loop, we check that we actually read digits; if not, we report an error;
- We expect to see the byte `'e'` ; if we find anything else, we report an error;
- We multiply the accumulated value with the multiplier to give it the right signedness and return a `BValue::Int`.

Not very hard and it will correctly parse Bencode integers, just like the nom version.

### Strings

Next up, string.
They have the following format:

```
# General form
<integer>:<bytes>

# Examples
0:        ("")
3:foo     ("foo")
3:foobar  ("foo")
```

As with integers, we'll only need our small utility methods glued with some loops and if statements.

```
impl Parser {
    fn parse_str(&mut self) -> Result<BValue, Error> {
        let mut len: usize = 0;
        while !self.eof() && self.peek().is_ascii_digit() {
            let b = self.advance();
            len = len * 10 + (b - b'0') as usize;
        }

        self.expect(b':')?;

        let mut buf = String::new();
        for _ in 0..len {
            let b = self.advance();
            if b == 0 {
                return Err(String::from("invalid string: reached EOF"));
            }
            buf.push(b as char);
        }
        return Ok(BValue::Str(buf));
    }
}
```

- We start by reading the digits of the length of the string in exactly the same way that we did for integers. One difference though is that we don't check to make sure that there actually were digits, because we know there is at least one: `parse_value` called us because it had peeked a leading digit.
- We consume a colon or report an error.
- We consume `len` bytes, pushing them into a String; if we encounter EOF before we've read all the characters, we report an error.

Two parsing functions down, two more to go.

### Lists and dictionaries

Let's tackle lists and dictionaries at the same time.
Their definitions will be recursive: they will read values by calling `parse_value`.
Recursion can be scary sometimes, but as we'll see, it makes the parsing methods very short.

```
impl Parser {
    fn parse_list(&mut self) -> Result<BValue, Error> {
        self.expect(b'l')?;
        let mut values: Vec<BValue> = Vec::new();
        while !self.eof() && self.peek() != b'e' {
            values.push(self.parse_value()?);
        }
        self.expect(b'e')?;
        return Ok(BValue::List(values));
    }

    fn parse_dict(&mut self) -> Result<BValue, Error> {
        self.expect(b'd')?;
        let mut values: Vec<(String, BValue)> = Vec::new();
        while !self.eof() && self.peek() != b'e' {
            let key = self.parse_str()?;
            let value = self.parse_value()?;
            if let BValue::Str(key) = key {
                values.push((key, value));
            } else {
                return Err(String::from("invalid dict: keys must be strings"));
            }
        }
        self.expect(b'e')?;
        return Ok(BValue::Dict(values));
    }
}
```

Let's focus on `parse_list`, since it's the simpler of the two.
We use `expect` to consume the opening `'l'`.
After we see the opening `'l'` (technically, since `parse_value` already saw the `'l'`, it would be correct to use `advance()`; I just like that the code for parsing a list shows the full structure of what a list looks like), we loop until EOF or until we peek an `'e'`, and each time we call `parse_value()` to get the next element from the list and store it in a vector.
This is the power of recursion: we could have lists within lists and this code would work correctly.
(We'd only get into trouble if the input had very deeply nested lists and blew the stack.)

For dictionaries, it's the same thing: we use `parse_str()` to read the key and `parse_value` to read the value.

### Putting a bow on it

At this point, we got a fully functional parser.
We can now add one method to wrap it nicely.
The `parse()` method will be our entry point; it will call `parse_value()` to get a Bencode value and then ensure that there's no extra garbage in the input.

```
impl Parser {
    pub fn parse(&mut self) -> Result<BValue, Error> {
        let value = self.parse_value()?;
        if self.eof() {
            return Ok(value);
        } else {
            return Err(String::from("garbage at the end of the input string"));
        }
    }
}
```

And there we go, a complete parser in about 150 lines of simple, beginner-level code!
No need for an extra dependency, no need to learn yet another API, no need to remember the intricacies of closures in Rust.
Just plain old, boring code.

## Pros and cons

Now, let's talk about the pros and cons of writing your own parser by hand.
This is computer science after all, which means that there's no _One Solution To Rule Them All_, only trade-offs to be weighed.
Let's start with the cons.

- It's easier to mess up. For example, we can make a mistake with `pos` and be pointing not exactly where we should be. Without good test coverage, a bug could lurk in a seldom-taken path and only appear in production.
- No shared "parsing language" between projects. Everyone on the project needs to learn how _this_ particular parser works; they don't benefit (as much) from past experience.
- It takes more code. If we want to whip out a small parser in a couple minutes, the hand-written approach will require more code, more typing, and will likely take more time than using a parsing library.

And the pros of the hand-written approach.

- Simpler code. As we saw, we only needed simple programming language features to build our Bencode parser. It's not rare for parsing libraries to lean into more complex features, like closures, macros, traits, etc. This makes it easier for people to jump into the code (i.e., they don't have to learn an external library) and it plays nicer with a debugger.
- Better error messages. One reason most production-level compilers have hand-written parsers is to give better error messages. When we can easily look at the state of the parser and have specific things for our language, it's easier to give the user a clear message; in parsers generated by libraries, the error messages are often more generic and give less context.
- Performance. We didn't spend one iota of energy in making our Bencode parser fast, but in my own tests, it runs about 3x faster than the nom-based parser.
- Fewer dependencies. Modern development relies very heavily on third-party libraries, with all the problems that can entail (e.g., left-pad). In Rust, extra dependencies can make the already-slow compile times even slower. Avoiding a third-party library avoids those extra liabilities.

Whether a hand-written parser or a library is preferable will depend on the project, but also on what you value.

## Conclusion

You can see the whole parser in [the Rust playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=97a6ee4c432abfe92f71b26346e8fd9f).

If you started reading this post thinking that parsing was difficult and needed specialized tools, I hope that this wall of text (and code) has helped you see that it's actually much simpler and easier than it might appear.
Of course, there are languages that are harder to parse than others and which will require more effort.
Bencode was relatively easy, but other languages might require more involved techniques, e.g., if we can't predict the next parsing method to call from just looking at the current byte, we may need to use a backtracking algorithm, which is harder, but in general, you'll probably find that predictive, recursive-descent parser are more often applicable than they are insufficient.
