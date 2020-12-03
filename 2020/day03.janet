(import spork/misc :as spork)

(defn descend [arr m start-x start-y dist-x dist-y]
  (if (>= (+ start-y dist-y) (length m))
    (length arr)
    (let [end-x (% (+ start-x dist-x) (-> (first m) length))
          end-y (+ start-y dist-y)
          tree? (= 35 (-> (in m end-y) (in end-x)))] # The character '#' is 35
      (when tree?
        (array/push arr true))
      (descend arr m end-x end-y dist-x dist-y))))

# Example

(def example
  (->>
    ```
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    ```
    spork/dedent
    string/trim
    (string/split "\n")))

(def example-answer
  (descend @[] example 0 0 3 1))

(print example-answer " trees")

# Part 1

(def part1-input
  (->> (slurp "day03.txt")
       string/trim
       (string/split "\n")))

(def part1-answer
  (descend @[] part1-input 0 0 3 1))

(print part1-answer " trees")

# Part 2

(def part2-input
  [[1 1]
   [3 1]
   [5 1]
   [7 1]
   [1 2]])

(def part2-answer
  (->> (map |(descend @[] part1-input 0 0 ;$) part2-input)
       (reduce * 1)))

(print part2-answer " trees")
