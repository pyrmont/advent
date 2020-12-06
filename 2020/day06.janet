(import spork/misc :as spork)

(defn count-any-answers [answers]
  (def counter @{})
  (each answer answers
    (unless (= answer 10) # newline
      (put counter answer true)))
  (length (keys counter)))

(defn count-every-answers [answers]
  (def counter @{})
  (def num-members (inc (or (count |(= $ 10) answers) 0)))
  (each answer answers
    (unless (= answer 10) # newline
      (put counter answer (inc (or (get counter answer) 0)))))
  (count |(= $ num-members) counter))

# Examples

(def example1
  (->>
    ```
    abcx
    abcy
    abcz
    ```
    spork/dedent))

(def example1-answer
  (count-any-answers example1))

(print "Example 1: " example1-answer " answers")

(def example2
  (->>
    ```
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    ```
    spork/dedent
    (string/split "\n\n")))

(def example2-answer
  (reduce (fn [total item]
            (+ total (count-any-answers item)))
          0 example2))

(print "Example 2: " example2-answer " answers")

(def example3-answer
  (count-every-answers example1))

(print "Example 3: " example3-answer " answers")

(def example4-answer
  (reduce (fn [total item]
            (+ total (count-every-answers item)))
          0 example2))

(print "Example 4: " example4-answer " answers")

# Part 1

(def part1-input
  (->> (slurp "day06.txt")
       string/trim
       (string/split "\n\n")))

(def part1-answer
  (reduce (fn [total item]
            (+ total (count-any-answers item)))
          0 part1-input))

(print "Part 1: " part1-answer " answers")

# Part 2

(def part2-answer
  (reduce (fn [total item]
            (+ total (count-every-answers item)))
          0 part1-input))

(print "Part 2: " part2-answer " answers")
