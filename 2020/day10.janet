(import spork/misc :as spork)

(defn tally-differences [adapters]
  (def res @{1 0 2 0 3 0})
  (var prev 0)
  (each adapter adapters
    (let [diff (- adapter prev)]
      (put res diff (inc (res diff)))
      (set prev adapter)))
  (put res 3 (inc (res 3)))
  res)

(defn group-adapters [adapters]
  (def res @[])
  (var prev 0)
  (var group @[0])
  (each adapter adapters
    (if (one? (- adapter prev))
      (array/push group adapter)
      (do (array/push res group)
          (set group @[adapter])))
    (set prev adapter))
  (if (one? (length group))
    (do (array/push group (+ prev 3))
        (array/push res group))
    (do (array/push res group)
        (array/push res @[prev (+ prev 3)])))
  res)

(defn lazy-caterer-number [group]
  (def group-length (- (length group) 2))
  (-> (+ (* group-length group-length) group-length 2)
      (/ 2)))

(defn calculate-permutations [groups]
  (->> (map lazy-caterer-number groups)
       (apply *)))

# Example

(def example1
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

(def example1-answer
  (tally-differences example1))

(print "There are " (example1-answer 1) " differences of 1 jolt"
       ", " (example1-answer 2) " differences of 2 jolts"
       " and " (example1-answer 3) " differences of 3 jolts")

(def example2
  (->>
    ```
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    ```
    spork/dedent
    (string/split "\n")
    (map scan-number)
    sort))

(def example2-answer
  (-> (group-adapters example2)
      calculate-permutations))

(print "The number of arrangements is " example2-answer)

# Part 1

(def part1-input
  (->> (slurp "day10.txt")
       string/trim
       (string/split "\n")
       (map scan-number)
       sort))

(def part1-answer
  (let [diffs (tally-differences part1-input)]
    (* (diffs 1) (diffs 3))))

(print "The multiplication of 1-jolt and 3-jolt differences is " part1-answer)

# Part 2

(def part2-answer
  (-> (group-adapters part1-input)
      calculate-permutations))

(print "The number of arrangements is " part2-answer)
