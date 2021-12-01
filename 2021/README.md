# Advent of Code 2021

These are answers to [Advent of Code 2021][aoc]. Like last year, I'm
writing my answers in [Janet][].

## Setup

Install [aoc-cli][]:

```shell
$ cargo install aoc-cli
```

Install [Jeep][]:

```shell
$ jpm install https://github.com/pyrmont/jeep
```

Install the dependencies:

```shell
$ jeep dev-deps
```

Start the netrepl server:

```shell
$ jeep netrepl --format "%.20m"
```

## Miscellaneous

### Editor

I recommend Neovim and [Conjure][]. Conjure pairs wonderfully with netrepl.

## Licence

This code is released into the public domain.

[aoc]: https://adventofcode.com/2021 "Advent of Code 2021"

[Janet]: https://janet-lang.org/ "Janet Programming Language"

[aoc-cli]: https://github.com/scarvalhojr/aoc-cli "aoc-cli, Advent of Code command-line helper tool"

[Jeep]: https://github.com/pyrmont/jeep "Jeep, an alternative project manager for Janet"

[Conjure]: https://conjure.fun "Conjure - Interactive evaluation for Neovim"
