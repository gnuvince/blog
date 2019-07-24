+++
date = "2019-07-13T09:48:50-04:00"
title = "Simple usage of GNU parallel"
+++

<!--
MAIN POINTS:
    - GNU Parallel can be really helpful to make some CLI tasks finish faster
    - GNU Parallel has a confusing interface
    - Two use cases: (1) run one command on multiple inputs, (2) run multiple commands
-->

[GNU Parallel](https://www.gnu.org/software/parallel/)<sup>1</sup> is
a great tool if you want to reduce the running time of a command-line
job.  Last week, I had a job that took 30+ minutes to run
sequentially, but finished in less than two minutes when I ran it with
Parallel on a 40-core machine.

Unfortunately, GNU Parallel does not have a very intuitive interface
and that's a significant hurdle for people who want to use it.  I've
been frustrated in the past, and I'm sure many of you reading have
too.  In this post, I'll show you how to use GNU Parallel to do two
basic, but very useful tasks:

1. Run *one* command on *multiple inputs* in parallel;
2. Run *multiple commands* in parallel.

## Setup

To help us in our examples, I have created a directory that contains
the files we'll work with.  Their names and their contents is listed
below.  You can download this directory [as a zip
file](https://vfoley.xyz/parallel-demo.zip).

```
a.txt:
Avocado

b.txt:
Broccoli

c.txt:
Cauliflower

cmdlist:
du -h a.txt
sha1sum b.txt
tr a-z A-Z <c.txt

filelist:
a.txt
b.txt
c.txt
```

## Running *one* command on *multiple inputs*

There are two ways to pass inputs to a command in GNU Parallel: via
the command-line arguments or via a file (or stdin).

You tell GNU parallel to take its inputs from the command line with
the `:::` operator.

```
$ parallel 'sha1sum {}' ::: *.txt
d8bcd7a949a2fb7a3e1740e4c61e52f46b781aea  a.txt
3db0058f7068968d90679ceb2184441c729782b9  b.txt
a9db4a2565b96696b594965ef52a98ebadfcc2b8  c.txt

$ parallel 'sha1sum {}' ::: a.txt cmdlist
d8bcd7a949a2fb7a3e1740e4c61e52f46b781aea  a.txt
814ca442838f9aa6ec2c01f5ed90de4620cfa990  cmdlist
```

In this example, the command we want to run is sha1sum and the `{}`
is a *placeholder* that is be replaced by an input when invoking the
command.

<i>(Note: Readers already familiar with GNU Parallel will see that I am
being overly explicit in these examples.  In the example above, I
didn't need to quote the command; in this particular case, I didn't
even need to use a placeholder.  But to be as clear as possible, I
will avoid the shortcuts in this post.)</i>

You tell GNU Parallel to take its inputs from a file with the `::::`
operator.  If the filename is `-`, GNU Parallel reads from stdin.

```
$ parallel 'sha1sum {}' :::: filelist
d8bcd7a949a2fb7a3e1740e4c61e52f46b781aea  a.txt
3db0058f7068968d90679ceb2184441c729782b9  b.txt
a9db4a2565b96696b594965ef52a98ebadfcc2b8  c.txt

$ grep [ac] filelist | parallel 'tr a-z A-Z <{}' :::: -
AVOCADO
CAULIFLOWER
```

I think you'll find this to be the most useful form of GNU Parallel.
You can build a Unix pipeline using familiar tools---sed, awk,
grep---to construct a list of inputs and then pipe them to parallel.

## Running *multiple commands* in parallel

To run multiple commands in parallel, use the placeholder as the
command name.  Like in the previous section, you obtain the command
name from the command-line arguments with the `:::` operator and from
a file or stdin with the `::::` operator.

```
$ parallel '{}' ::: 'du -h a.txt' 'rot13 <b.txt'
4.0K        a.txt
Oebppbyv

$ parallel '{} a.txt' ::: sha1sum 'du -h' 'xxd'
d8bcd7a949a2fb7a3e1740e4c61e52f46b781aea  a.txt
4.0K        a.txt
00000000: 4176 6f63 6164 6f0a                      Avocado.

$ parallel '{}' :::: cmdlist
4.0K	a.txt
3db0058f7068968d90679ceb2184441c729782b9  b.txt
CAULIFLOWER

$ grep [ac].txt$ cmdlist | parallel '{}' :::: -
4.0K	a.txt
CAULIFLOWER
```

## Conclusion

This was a super simple introduction to GNU Parallel; there are a lot
of features that we didn't cover:

- composing and permuting the inputs from multiple files
- controlling the number of concurrent jobs
- spreading jobs across multiple machines
- using advanced placeholder functionality

But now that you have a more firm grasp of the basic concepts, you can
work your way up to this advanced functionality.

<i>Thank you to Simon Symeonidis for proof-reading this article.</i>

<hr>
<sup>1</sup> O. Tange (2011): GNU Parallel - The Command-Line Power
Tool, ;login: The USENIX Magazine, February 2011:42-47.
