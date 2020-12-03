(import spork/misc :as spork)

(defn find-2-tuple [list]
  (->> (seq [x :in list
             y :in list :when (= 2020 (+ x y))]
         [x y])
       first
       (apply *)))

(defn find-3-tuple [list]
  (->> (seq [x :in list
             y :in list
             z :in list :when (= 2020 (+ x y z))]
         [x y z])
       first
       (apply *)))

# Example

(def example
  (->>
    ```
    1721
    979
    366
    299
    675
    1456
    ```
    spork/dedent
    string/trim
    (string/split "\n")
    (map scan-number)))

(def example-answer
  (find-2-tuple example))

# Part 1

(def input
  (slurp "day01.txt"))

(def expenses
  (->> (string/trim input)
       (string/split "\n")
       (map scan-number)))

(def part1-answer
  (find-2-tuple expenses))

(print part1-answer)

# Part 2

(def part2-answer
  (find-3-tuple expenses))

(print part2-answer)
