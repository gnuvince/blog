+++
date = "2019-07-24T00:01:20-04:00"
title = "Objective font criterias"
+++

<!--
MAIN POINTS:

    - The most important criteria when choosing a font: do you like it?
    - But there are other, less subjective criterias that you would do well to keep in mind:
        1. License: do you need to buy a license? Can you use the font freely for personal use? Can you use it for your website or in your book?
        2. Glyph support: does the font support many Unicode glyphs? It could be important if you speak a foreign language or play roguelikes
        3. Weights and styles: Some fonts only have the roman face; do you want/need bold, italic, thinner and/or thicker strokes?
        4. Customization: can you customize the way the font looks?
        5. Active development: can you expect new glyphs to be added, problems to be fixed? Or is the font "done"?
-->
When you choose a font, the most important criteria is “do you like it, and could you stand to look at it for 8 hours per day?”
There's no accounting for taste, so if the short leg of the the letter `m` in [Ubuntu Mono] really bugs you, then you should pick a different font and don't let anyone tell you that you're wrong.
But fonts have characteristics that aren't subjective, and when you're choosing a new font, it makes sense to consider these as well.

## License
Some fonts require that you purchase a license to use them and they might impose limits on how many people can use them.
[PragmataPro] and [Triplicate] are such fonts.
Others can be used free of charge for private use---[Input] for example---but a license must be purchased if you want to use them on your website or in a print publication.
In the open source community, many fonts use the [SIL Open Font License].
You can use, modify, and redistribute those fonts freely; derivative work must be licensed under the same terms---the OFL is a copyleft license---and the fonts may not be sold.
Fonts licensed under the terms of the OFL include [Fantasque Sans Mono], [Iosevka], and [Inconsolata].
You can use these on your blog or in your papers or package them with your applications without worry.

## Unicode coverage
Some fonts like [DejaVu] have extensive Unicode support, and are appropriate for people who write in foreign languages, who write mathematics, or who just want to use emojis.
When fonts don't have good Unicode coverage, some of the unsupported glyphs will be replaced with a blank square, or sometimes a fallback font can be used and that can break the homogeneity of the text.

If you play roguelikes, some (e.g., [Dungeon Crawl: Stone Soup]) use Unicode characters to display dungeon features.
I've seen glyphs overlap when using some fonts, typically when a symbol is left of a common character.
If this happens to you, try using a different font when playing.

## Weights and slants
Anyone who's used a word processor knows how to make fonts bold and/or italic.
But did you know that not all fonts have bold or italic variants?
Did you know that some fonts have multiple weights, not just bold?

[Monaco] and [Droid Sans Mono] are example of fonts that just have the regular variant---they don't have italics or bold.
[Fira Code] comes in three weights---light, regular, and bold---but it has no italics.
Many programmer fonts offer regular, bold, italic, and bold-italic faces:
[Fantasque Sans Mono], [Meslo], [Consolas], [Inconsolata], and many more.
Finally, some fonts offer many different weights going from very thin to very thick.
[Input] and [Iosevka] are such fonts.

## Customization
Most fonts are given to you as-is---what you see is what you get.
However, some fonts let users customize them.
[Iosevka] offers 12 stylistic sets out of the box, and if none are entirely satisfactory, you can modify a TOML file and specify exactly the glyphs that you want.
Before downloading [Input] you can customize the glyph for some characters (g, i, l, 0, *, and the braces).
[Hack], a font based on DejaVu Sans Mono, has a [repository] of alternative glyphs; if you don't like some of their glyphs, for example their zero, you can change them to something more classic.

## Active development
Some fonts are “done”; they are no longer being developed.
This can be frustrating if you find problems with the font and no one can fix it.
At the time of writing this post, many font projects were in active development:
[Iosevka], [Fira Code], [IBM Plex], and many more.

[Consolas]: https://en.wikipedia.org/wiki/Consolas
[DejaVu]: https://dejavu-fonts.github.io/
[Droid Sans Mono]: https://en.wikipedia.org/wiki/Droid_fonts
[Fantasque Sans Mono]: https://github.com/belluzj/fantasque-sans
[Fira Code]: https://github.com/tonsky/FiraCode
[Hack]: https://github.com/source-foundry/hack
[IBM Plex]: https://github.com/IBM/plex
[Inconsolata]: https://levien.com/type/myfonts/inconsolata.html
[Input]: https://input.fontbureau.com/
[Iosevka]: https://github.com/be5invis/Iosevka/
[Meslo]: https://github.com/andreberg/Meslo-Font
[Monaco]: https://en.wikipedia.org/wiki/Monaco_(typeface)
[PragmataPro]: https://www.fsd.it/shop/fonts/pragmatapro/
[SIL Open Font License]: https://en.wikipedia.org/wiki/SIL_Open_Font_License
[Triplicate]: https://practicaltypography.com/triplicate.html
[Ubuntu Mono]: https://en.wikipedia.org/wiki/Ubuntu_(typeface)
[repository]: https://github.com/source-foundry/alt-hack
[Dungeon Crawl: Stone Soup]: https://crawl.develz.org/
