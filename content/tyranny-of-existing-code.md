+++
date = "2023-03-12"
title = "The Tyranny of Existing Code"
+++

Most programmers have experienced that feeling of worthlessness and powerlessness when we are trying to implement what should be a simple change, but the existing code base resists our attempts.
Worse, often we can see what is causing us to be blocked, yet we cannot bring ourselves to bring down those barriers.
I call this _the tyranny of existing code_.

In a young software project, one with little infrastructure in place, it's usually straightforward to make changes.
However in a project that's older, one where other programmers have put in place structures to make the codebase "clean", "maintainable", or "extensible", it's often much harder to make changes.
Often, the structures that have been put there "to make changes easier" or "to make it harder to shoot yourself in the foot" are the very ones that block us.

And it is the tyranny of existing code that will prevent us—at least initially—from taking the steps needed to unblock ourselves.
We reason that if there are restrictions in place, "they must be there for a reason".
We think about the time that the the original author must have spent to design and implement those structures and we don't want to insult them by deleting their code.
We certainly don't want to put ourselves in a position where we think we know more than them, only to be shown to be wrong.
We show deference to the existing structure by trying to work within its constraints and limitations, even as it impedes our ability to solve the problem.
We day dream of ripping out all that shitty code and replacing it with our own and how much better it would all be; but we quickly return to reality, continue grinding at the problem, and continue finding new ways in which the current code blocks us.
And so we waste hours, days, even weeks, letting the existing code make our lives miserable.

For example, suppose that the web framework of our application hides the HTTP headers behind a dictionary-like abstraction and only provides the ability to get a specific header.

```rust
impl HttpRequest {
    fn get_header(header_name: &str) -> Option<&str>;
}
```

If we were tasked with logging all the headers of incoming requests, how would we do it?
The current interface is clearly insufficient—we need access to all the headers—but what can we do?
We might think about replacing the framework for one that does not hide the headers, but that suggestion sounds ludicrous and risky and will make us sound naïve and unprofessional.
So we start looking for ways to work within the framework.
Maybe there's a new version that exposes the headers?
Maybe there's a middleware system that let us access the raw request?
There's probably, definitely a reason why the original author didn't want us to have access to all the headers—we don't know what kind of problems they have saved us from by not giving us access to all the headers and we should be thankful; really, it's our task that's the problem!

In time, we find a solution, make our change, and we feel good about ourselves; we overcame the difficulties, our manager congratulated us at the stand-up, and we didn't need to throw a bunch of existing code in the garbage.
We might feel a bit bad about the time and effort it took us and about the extra complexity we introduced though; but it's better to have made the change than to have re-written the whole thing, right?

But what will happen next time?
Are we going to leave the structures in even as they become more and more inappropriate for the kinds of changes we need to make?
Are we going to live with them even as they make further changes more difficult and the complexity of the project continues to increase?

The tyranny of existing code suggests that yes, we will.
Code does not have mass, but it has a gravitational pull.
The larger and more complex the code, the more energy is required to escape it: more code to understand, more code to replace, more managers to convince, more programmers to get on board, etc.
Eventually, the code that only needed to handle simple HTTP requests has become so complex because of the web framework and the extra layers of complexity that we added that simple changes require weeks of work and no one dares suggest that the problem is the web framework and that it needs to be replaced.
