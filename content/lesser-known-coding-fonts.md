+++
title = "Lesser Known Coding Fonts"
date = 2019-10-17
draft = false
tags = []
categories = []
+++
<style>
    table {
        font-family: monospace;
    }
    th {
        width: 170px;
        font-weight: normal;
    }
    th, td {
        border-left: 1px solid;
        border-right: 1px solid;
        border-top: 0px;
        border-bottom: 0px;
    }
    div.small {
        font-size: 10pt;
        color: #888;
    }
</style>

<!--
PLAN:
    1. I've become more interested in fonts for programmers in past few months; looking at them all day, multiple purposes
    2. Great place to see fonts other programmers use: /r/unixporn
    3. My current impression: #1 is Hack, lots of system fonts, many open source fonts
    4. Here are 5 fonts that I see less often, but deserve attention

APL385:
    - Font for APL, lots of horizontal and vertical space, curviness and rounded terminators makes it look whimsical.
    - Easy to distinguish most characters, though the lack of slashed or dotted zero can cause confusion with the uppercase Oh.
    - At small sizes on Linux the font is jaggy

Go Mono:
    - Font from Go Project, only serif font in my list (little legs).
    - Easy to distinguish all characters, but the absence of a gap between underscores can be annoying for Python users.
    - Surprisingly readable at small sizes
    - There is a proportional version that is serviceable for code if that's your thing (it is Rob Pike's thing)

Sudo:
    - One programmer decided to draw his own coding font, been working on it since 2009
    - Easy to distinguish all characters
    - The digits are a bit shorter than uppercase letters
    - Some glyphs don't yet have their curves drawn and look pixelated (e.g., lowercase theta or superscript 3)
    - It has a Variable Open Font version, i.e., one font for regular, italics, bold, and bold italic.

Monoid:
    - Another coding font made by a programmer
    - Goal: extreme readability, even at very small sizes; it has a bitmap look (but isn't bitmapped)
    - Easy to distinguish all characters
    - Can be customized: before downloading you can change the shape of the characters `$01l`, the line spacing, and the tracking (horizontal spacing between characters)
    - Ligatures can be turned on or off
    - Companion Monoisome

Input Mono:
    - Only non-free font in the list
    - Free for private use, must purchase a license to use in a book or your website
    - Drawn by a professional font designer, David Jonathan Ross
    - Easy to distinguish all characters
    - Can be customized: before downloading you change the shape of the characters `0agil{*}`, the line spacing.
    - Available in three widths: regular, condensed, compressed
    - Powerline-ready out of the box
    - There's also a serif and a sans-serif proportional version
-->

In the past few months, I've become interested---fascinated even---by programming fonts.
As programmers we look at text all day: code, logs, command outputs, monitoring tools, etc.
If we're going to be looking at text all day, we might as well make it easy and pleasant for our eyes to read that text.

One great place to see the fonts used by other people is at [/r/unixporn](https://www.reddit.com/r/unixporn/).
I have not conducted a thorough survey, but from my observations it seems that, currently, the most popular font for the ricers of /r/unixporn is [Hack](https://sourcefoundry.org/hack/).
As we might expect, many use the built-in system fonts: DejaVu Sans Mono and Ubuntu Mono for Linux; Monaco, Menlo, and SF Mono on macOS.
High-quality open source fonts are also very well represented: Fira Code, Inconsolata, Iosevka, Noto, Roboto Mono, and Source Code Pro.

In this post, I want to show five fonts that I don't see as often on /r/unixporn, but which I believe deserve to be better known.
(Edit: ironically enough, this post cannot be posted on /r/unixporn, because they don't accept content that isn't screenshots, photos, or videos.)

## APL385 Unicode

The first font I want to suggest is APL385 Unicode.
APL is a programming language where operations are denoted with operators.
In order to make APL code more readable, APL385 has generous spacing between lines and between characters.
The terminators (the end of strokes) are rounded which gives the font a fun, whimsical look.

[![APL385 Unicode](/font-screenshots/apl385.png)](/font-screenshots/apl385.png)
<center><div class="small">(Click on the image to zoom)</div></center>

As a programming font, the majority of characters are easy to distinguish, however the lack of slashed or dotted zero can cause confusion with the uppercase Oh.
APL385 does not support Powerline glyphs, and there isn't a patched version like there exists for other fonts.

One thing to note, at least on Linux: at smaller font sizes, the hinting is very bad and the font looks very jaggy.
Not recommended if you like very small font sizes.

<table>
<tr>
    <th>Homepage</th>
    <td><a href="http://apl385.com/fonts/">http://apl385.com/fonts/</a></td>
</tr>
<tr>
    <th>License</th>
    <td>Public domain</td>
</tr>
<tr>
    <th>Glyph count</th>
    <td>769</td>
</tr>
<tr>
    <th>Weights</th>
    <td>Regular</td>
</tr>
<tr>
    <th>Italics?</th>
    <td>No</td>
</tr>
<tr>
    <th>Ligatures?</th>
    <td>No</th>
</tr>
<tr>
    <th>Customizable?</th>
    <td>No</td>
</tr>
</table>

## Go Mono

Go Mono is one of the typeface in the Go type family.
These fonts were created by the professional firm Bigelow & Holmes, and released under the BSD license.
Go Mono is the only serif font in this list.
(Serifs are the little “legs” at the end of some strokes.)

[![Go Mono](/font-screenshots/go-mono.png)](/font-screenshots/go-mono.png)
<center><div class="small">(Click on the image to zoom)</div></center>

Like most programming fonts, all the characters are easy to distinguish, though I will point out the lack of spacing between consecutive underscores; this can be annoying to people who code in languages like Python where the double-underscore is used quite often.
Go Mono is easy to read at very small sizes: even with my aging eyes, it's not difficult for me to make out words at 8 points (although I recommend using a larger font size!)
Like the majority of coding fonts, Go Mono comes in two weights, regular and bold, and it has an italic version.

As the name suggests, Go Mono is monospaced; the proportional typeface of the family, Go, is actually serviceable as a coding font.
Typically, proportional fonts such as Times or Helvetica suck as coding fonts, but Go makes all characters distinguishable.
If you want to try something different, you may want to try coding with a proportional font.

<table>
<tr>
    <th>Homepage</th>
    <td><a href="https://blog.golang.org/go-fonts">https://blog.golang.org/go-fonts</a></td>
</tr>
<tr>
    <th>License</th>
    <td>BSD</td>
</tr>
<tr>
    <th>Glyph count</th>
    <td>661</td>
</tr>
<tr>
    <th>Weights</th>
    <td>Regular, Bold</td>
</tr>
<tr>
    <th>Italics?</th>
    <td>Yes</td>
</tr>
<tr>
    <th>Ligatures?</th>
    <td>No</th>
</tr>
<tr>
    <th>Customizable?</th>
    <td>No</td>
</tr>
</table>

## Sudo

Sudo is the work of one programmer, Jens Kutílek, who decided to create his own coding font in 2009 and is still actively developing it.

[![Sudo](/font-screenshots/sudo.png)](/font-screenshots/sudo.png)
<center><div class="small">(Click on the image to zoom)</div></center>

Sudo is a narrow font, so if you like having two or three side-by-side splits in your text editor, Sudo is a good choice.
All the characters in Sudo are easy to distinguish, and there is a gap between consecutive underscores.
One characteristic of Sudo is the height of digits: they are a bit shorter than capital letters; this helps to further disambiguate, say, the digit one and the letter el.

Sudo has a variable font download option, i.e., a single font file that contains the regular, bold, and italic glyphs.
This reduces network transfers if you want to use Sudo on your website.

One thing you'll note about Sudo is that some characters (e.g., the superscript 3 or the lowercase theta) are very pixelated.
This is due to the way the font designer works: he creates a pixel version first, then he draws the curves.
The pixelated characters are the characters he hasn't yet gotten around to drawing.

<table>
<tr>
    <th>Homepage</th>
    <td><a href="https://www.kutilek.de/sudo-font/">https://www.kutilek.de/sudo-font/</a></td>
</tr>
<tr>
    <th>License</th>
    <td>OFL</td>
</tr>
<tr>
    <th>Glyph count</th>
    <td>1071</td>
</tr>
<tr>
    <th>Weights</th>
    <td>Regular, Bold</td>
</tr>
<tr>
    <th>Italics?</th>
    <td>Yes</td>
</tr>
<tr>
    <th>Ligatures?</th>
    <td>No</th>
</tr>
<tr>
    <th>Customizable?</th>
    <td>No</td>
</tr>
</table>


## Monoid

Like Sudo, Monoid is another coding font that was developed by a programmer, Andreas Larsen.
Monoid's number one goal is extreme readability, especially at smaller font sizes and its look reminds of bit-mapped fonts.

[![Monoid](/font-screenshots/monoid.png)](/font-screenshots/monoid.png)
<center><div class="small">(Click on the image to zoom. Note: this is my own customized version of Monoid. The characters <tt>01l$</tt> might look different for you.)</div></center>

All the characters in Monoid are easy to distinguish. While researching Monoid, I learned that they made an effort to distinguish the Cyrillic letter Ze (З) and the number three (3) by giving three a flat-top.
The characters `01l$` can be customized before download; you can also adjust the line spacing and the tracking---the spacing between characters.
Monoid is the only font in this list to feature programming ligatures, and these can be turned off if you don't like them.

The creator of Monoid [gave a talk](https://www.youtube.com/watch?v=hdld21mlzbY) about the language; the audio quality is not great, but you can learn a lot from this presentation.

<table>
<tr>
    <th>Homepage</th>
    <td><a href="https://larsenwork.com/monoid/">https://larsenwork.com/monoid/</a></td>
</tr>
<tr>
    <th>License</th>
    <td>MIT + OFL</td>
</tr>
<tr>
    <th>Glyph count</th>
    <td>618</td>
</tr>
<tr>
    <th>Weights</th>
    <td>Regular, Bold</td>
</tr>
<tr>
    <th>Italics?</th>
    <td>Yes</td>
</tr>
<tr>
    <th>Ligatures?</th>
    <td>Yes (optional)</th>
</tr>
<tr>
    <th>Customizable?</th>
    <td>Yes</td>
</tr>
</table>

## Input Mono

The last language in our list is Input Mono, a font for programmers by professional font designer Jonathan David Ross.
Unlike the other fonts in this list, Input Mono is not open source: it is free for private use, but if you wish to use it on your website or in a print publication, you must purchase a license.

[![Input](/font-screenshots/input.png)](/font-screenshots/input.png)
<center><div class="small">(Click on the image to zoom. Note: this is my own customized version of Input; the characters <tt>0agil{*}</tt> might look different for you.)</div></center>

All the characters in Input are easy to distinguish and it comes with Powerline support out of the box.
At the download screen, you can customize Input: you can choose your shape of choice for the characters `0agil{*}` and you can increase or decrease the line spacing.

Input Mono is part of a **massive** font family.
In addition to the monospaced variant, there is a sans-serif proportional variant and a serif proportional variant.
Though they aren't monospaced, they are designed with programmers in mind.
Then, each of the three variants comes in three widths: regular, narrow, and condensed.
If you'd like for Input to be as slim as Sudo, it can.
Finally, each font has seven weights and an associated italic.
Put it all together, and Input has **126** different fonts for you to choose from.

Input Mono has been my daily driver for many months, and I only have good things to say about it.
If you want to hear more about Input, you can watch Jonathan David Ross's presentation, [Cracking the Code](https://www.youtube.com/watch?v=SzC3qTo0p1k).

<table>
<tr>
    <th>Homepage</th>
    <td><a href="https://input.fontbureau.com/">https://input.fontbureau.com/</a></td>
</tr>
<tr>
    <th>License</th>
    <td>Free for personal use</td>
</tr>
<tr>
    <th>Glyph count</th>
    <td>921</td>
</tr>
<tr>
    <th>Weights</th>
    <td>Thin, Extra Light, Light, Regular, Medium, Bold, Black</td>
</tr>
<tr>
    <th>Italics?</th>
    <td>Yes</td>
</tr>
<tr>
    <th>Ligatures?</th>
    <td>No</th>
</tr>
<tr>
    <th>Customizable?</th>
    <td>Yes</td>
</tr>
</table>
