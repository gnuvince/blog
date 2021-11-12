+++
title = "On 'Clean Code'"
date = 2021-11-12
draft = false
tags = []
categories = []
+++
Many programming books exist that give advice on how we can make our code clean; it seems to be quite a lucrative industry, because these keeping coming out year after year and programmers keep buying them.

Unfortunately, these books mostly concern themselves with what the text of the code ought to look like, and not with what the code itself ought to be.
They give advice such as "use meaningful names", "keep methods short", "prefer dynamic dispatch to `switch`", "depend upon abstractions, not concretions", etc., but programs that abide by that advice are not magically readable or clean.
(In fact, it seems that the more of this advice that we apply to a program, the more we create a "clean mess".)
But if we got the core of the program wrong---solving the wrong problem, using the wrong tool, having piles of unnecessary abstractions---no amount of advice about using private fields instead of public ones is going to meaningfully improve our program.

These books should be understood as our industry's *Strunk and White* or *The Chicago Manual of Style*: the advice they give on what _text_ ought to look like can be useful, but if an article is uninteresting, readers won't care our about our usage of oxford commas.

So let's make sure when we review our peers' code that we don't miss the forest for the trees and give them endless suggestions about how they could make their code "cleaner" by changing superficial details and instead focus on whether their general approach to the problem is sound or whether new requirements justify a different overall architecture.
