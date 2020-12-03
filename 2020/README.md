# Advent of Code 2020

These are answers to [Advent of Code 2020][aoc]. This year, I'm writing my
answers in [Janet][].

## Usage

Install the dependencies:

```shell
$ mkdir modules
$ JANET_PATH=modules jpm deps
```

Run the REPL:

```shell
$ ./repl
```

## Miscellaneous

### Network REPL

This repository includes a script, `repl`, for running a REPL that can be
connected to over a network.  I use this with Neovim and [Conjure][].

### Module Installation

Modules are installed into the `modules/` directory.

## Licence

This code is released into the public domain.

[aoc]: https://adventofcode.com/2020 "Advent of Code 2020"

[Janet]: https://janet-lang.org/ "Janet Programming Language"

[Conjure]: https://conjure.fun "Conjure - Interactive evaluation for Neovim"
