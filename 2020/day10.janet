(import spork/misc :as spork)

(defn record-differences [adapters]
  (def res @{1 0 2 0 3 0})
  (var prev 0)
  (each adapter adapters
    (let [diff (- adapter prev)]
      (put res diff (inc (res diff)))
      (set prev adapter)))
  (put res 3 (inc (res 3)))
  res)

# Example

(def example
  (->>
    ```
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    ```
    spork/dedent
    (string/split "\n")
    (map scan-number)
    sort))

(def example-answer
  (record-differences example))

(print "There are " (example-answer 1) " differences of 1 jolt"
       ", " (example-answer 2) " differences of 2 jolts"
       " and " (example-answer 3) " differences of 3 jolts")

# Part 1

(def part1-input
  (->> (slurp "day10.txt")
       string/trim
       (string/split "\n")
       (map scan-number)
       sort))

(def part1-answer
  (let [diffs (record-differences part1-input)]
    (* (diffs 1) (diffs 3))))

(print "The multiplation of 1-jolt and 3-jolt differences is " part1-answer)
