# Bash Libs : Native

<small>(C) 2019 Tai Kedzierski, LGPLv3</small>

Some lib files for [bash builder][1] implementing some basic functionality equivalent to Unix commands, but only using bash language constructs, not external processes.

The initial impetus for starting this was to get around the performance hits introduced by Windows's process spawning. Loops that use common functions become inordinately costly due to the several hundreds of milliseconds needed to spawn a new process - case in point, using `find` with `exec`.

`test-native.sh` is a simple script that searches for `*.sh` files that call the `debug:*` library, doing so 10 times for each the "classic" processes, and the `native:` implementations. It takes a single argument, which should be the path to your standard libs folder. It needs [`bbrun`][1] or to be compiled by bash-builder

The results don't look superb for Linux - `native:*` seems half as fast as just running the standard executables (mainly grep), quite probably because of the amount of work done in bash to replicate find itself.

```
Testing normal

    real    0m0.987s
    user    0m0.712s
    sys 0m0.170s

Testing native

    real    0m1.542s
    user    0m1.347s
    sys 0m0.175s
```

but show quite the difference for Windows (git bash/mingw64), being three to four times faster in `native:` (11.3s) than spawning grep processes (36.2s):

```
Testing normal

    real    0m36.259s
    user    0m5.609s
    sys     0m16.247s

Testing native

    real    0m11.352s
    user    0m1.578s
    sys     0m9.781s
```

My conclusion: it's probably not worth continuing this project any further, unless a high incidence of Windows users emerges for Bash Builder. I was mainly planning on re-implementing those parts that I could so as to speed up [`git-shortcuts`][2] for Windows use, but the gain on one, whilst significant, would mean a noticeable performance loss on Linux - and I hardly use Windows myself, so not really interested in investing time into what will mostly be a performance loss.

This page mainly stays as a reference/comparison/napkin-note on the topic, no more...

[1]: https://github.com/taikedz/bash-builder
[2]: https://github.com/taikedz/git-shortcuts
