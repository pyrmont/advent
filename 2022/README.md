# Advent of Code 2022

These are answers to [Advent of Code 2022][aoc]. This year I'm writing my
answers in [Clojure][].

## Setup

Install [aoc-cli][]:

```shell
$ cargo install aoc-cli
```

Create a shell function to download the puzzle instructions and input and save
to files that are in the form `day<n>.txt` and `day<n>.input` respectively:

```shell
$ aocc() { aoc -o -y 2022 -d $1 read -p day$1.txt > /dev/null; aoc -o -y 2022 -d $1 download -i day$1.input }
```

Start the nrepl server:

```shell
$ clojure -M:nrepl
```

## Miscellaneous

### Editor

I recommend Neovim and [Conjure][]. Conjure pairs wonderfully with [nREPL][].

## Licence

This code is released into the public domain.

[aoc]: https://adventofcode.com/2022 "Advent of Code 2022"

[Clojure]: https://clojure.org/ "The Clojure Programming Language"

[aoc-cli]: https://github.com/scarvalhojr/aoc-cli "aoc-cli, Advent of Code command-line helper tool"

[Conjure]: https://conjure.fun "Conjure - Interactive evaluation for Neovim"

[nREPL]: https://nrepl.org "nREPL"
