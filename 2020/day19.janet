(defn make-sequence [pattern]
  (def seqs (->> (string/trim pattern)
                 (string/split " ")
                 (map keyword)))
  (if (> (length seqs) 1)
    (->> (array/concat @['*] seqs)
         (apply tuple))
    (first seqs)))

(defn make-choice [pattern]
  (def choices (->> (string/split "|" pattern)
                   (map make-sequence)))
  (if (> (length choices) 1)
    (->> (array/concat @['+] choices)
         (apply tuple))
    (first choices)))

(def grammar
  ~{:main (some (* :key :pattern (? :nl)))
    :nl "\n"
    :sp (some " ")
    :key (* (/ (<- :d+) ,keyword) ":" :sp)
    :pattern (+ :x-ref :literal)
    :x-ref (/ (<- (* :d+ (any (* :sp (+ :d+ "|"))))) ,make-choice)
    :literal (* `"` (<- :w+) `"`)})

(defn to-grammar [input]
  (->> (peg/match grammar input)
       (array/concat @[:main ~(* (<- :0) -1)])
       (apply struct)))

# Example

(def example1
  (->>
    ```
    0: 1 2
    1: "a"
    2: 1 3 | 3 1
    3: "b"
    ```))

(def example1-grammar
  (to-grammar example1))

(def example1-answer
  (->> (map |(peg/match example1-grammar $) ["aab" "aba" "abb"])
       (count |(not (nil? $)))))

(print "The number of matches is " example1-answer)

(def example2
  (->> (slurp "day19-example.txt")
       string/trim
       (string/split "\n\n")))

(def example2-grammar1
  (->> (first example2)
       to-grammar))

(def example2-answer1
  (->> (example2 1)
       (string/split "\n")
       (map |(peg/match example2-grammar1 $))
       (count |(not (nil? $)))))

(print "The number of matches is " example2-answer1)

(def example2-grammar2
  (let [res @{}]
    (each [k v] (pairs (to-grammar (first example2)))
      (case k
        :0 (put res k ~(* (at-least 2 :42) (some :31)))
        (put res k v)))
    (table/to-struct res)))

(def example2-answer2
  (->> (example2 1)
       (string/split "\n")
       (map |(peg/match example2-grammar2 $))
       (count |(not (nil? $)))))

(print "The number of matches is " example2-answer2)

# Part 1

(def part1-input
  (->> (slurp "day19.txt")
       string/trim
       (string/split "\n\n")))

(def part1-grammar
  (->> (first part1-input)
       to-grammar))

(def part1-answer
  (->> (part1-input 1)
       (string/split "\n")
       (map |(peg/match part1-grammar $))
       (count |(not (nil? $)))))

(print "The number of matches is " part1-answer)

# Part 2

(def part2-grammar
  (let [res @{}]
    (each [k v] (pairs part1-grammar)
      (case k
        :0 (put res k
                ~(drop (cmt (* (<- (at-least 2 :42))
                               (<- (some :31)))
                            ,(fn [x y] (< (length y) (length x))))))
        (put res k v)))
    (table/to-struct res)))

(def part2-answer
  (->> (part1-input 1)
       (string/split "\n")
       (map |(peg/match part2-grammar $))
       (count |(not (nil? $)))))

(print "The number of matches is " part2-answer)
