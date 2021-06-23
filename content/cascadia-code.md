+++
title = "My quick review of Cascadia Code"
date = 2019-09-19
draft = false
tags = []
categories = []
+++
<style>
@font-face{
    font-family: cascadiaCode !important;
    src: url("/Cascadia.ttf");
}
h1, h2, h3, p, pre, code {
    font-family: cascadiaCode !important;
}
</style>

On September 18th, 2019, Microsoft released a new typeface for coders, [Cascadia Code](https://devblogs.microsoft.com/commandline/cascadia-code/).
Cascadia was designed for usage inside Microsoft's new Terminal application and inside coding editors like VSCode or Emacs.
Although it is still just one day old, I thought I'd give my thoughts on Cascadia.

## The good
Microsoft released Cascadia Code under the terms of the SIL Open Font License, a copyleft license for typefaces:
the author gives up all profit from the sale of the font, but all derivatives must abide by the same terms.
This is great as it ensures that the development of Cascadia Code can continue even if Microsoft no longer has the resources to dedicate to the project.
The OFL also allows anyone to freely use the font on their website, in their screencasts, in their Power Point presentations, in their published articles, in their books, etc.

I think that Cascadia Code looks really good!
When I first used Ubuntu Mono and Fantasque Sans Mono, I was really taken by how whimsical they looked compared to other coding typefaces.
The common coding typefaces -- DejaVu Sans Mono, Menlo, Consolas, Courier -- are all very straight and, dare I say, soulless.
Cascadia Code has the “fun” quality that Ubuntu Mono and Fantasque Sans Mono have.
Maybe we'll look back on Cascadia in a few years and say, “oh, that typeface is *so* 2020!”, but for now I think it brings a needed freshness to coding fonts.
Some fonts are easily identifiable by some of their characters; I believe that the `f`, the `k`, and the `4` are going to be how most people will recognize Cascadia Code.

Cascadia is easy to read at small sizes; even at 10 points, I have an easy time reading.
(Although, for the sake of your eyes, please don't use tiny font sizes!)

If ligatures are your kind of thing, has a number of them.
I don't use ligatures myself, so I can't comment on their quality versus other contenders like Fira Code or Iosevka.

In Cascadia Code, the characters that can look similar in regular typefaces are nicely distinct.
For example, here's what the characters that look like the letter “ell” look like:

    iIl1|

This is just my opinion, but I don't think there is any ambiguity here.
Same with the “oh's”:

    oO0

The dot inside the zero makes it clear that it's a numeral and not a letter.

## The bad
Cascadia Code's “bad” is mostly a product of its age.
First, it does not support characters with accents, which is necessary for people who write in a foreign language.
It also misses many glyphs such as dashes, mathematical symbols, and some symbols used in roguelikes.
I'm sure that as Cascadia Code ages, more glyphs will be added.

Another bad aspect of Cascadia that's certainly a product of its young age: it has no bold face nor italics.
It also doesn't have multiple weights like Source Code Pro or Input.
Again, I'm sure we just have to be a bit patient.

It appears to me that in order to contribute to the development of the font I need to use Windows- and MacOS-only tools.
Not an atypical situation, but it chagrins me when an open font project uses tools that lock out people who would like to contribute.
(I think this shows that there is a need for a better open sourced font development ecosystem.)

## Conclusions
I used Cascadia Code today at work and for writing this post.
I think it's a nice font, it's easy to read, and I don't mind some of the quirky characters (e.g., f and k)
as much as I thought I would.

I definitely recommend that you give it a try, and I wish the team developing Cascadia Code all the best.
I can't wait for the release that has support for accented characters!

<i>Thank you to Stefan Knudsen for reporting a typo.</i>
