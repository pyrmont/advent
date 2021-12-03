(defn tally-bits [counts bit]
  (if (= "0" bit)
    [(inc (counts 0)) (counts 1)]
    [(counts 0) (inc (counts 1))]))

(defn mcb [& bits]
  (def counts (reduce tally-bits [0 0] bits))
  (if (> (counts 0) (counts 1))
    "0"
    "1"))

(defn lcb [& bits]
  (def counts (reduce tally-bits [0 0] bits))
  (if (<= (counts 0) (counts 1))
    "0"
    "1"))

(defn to-base10 [digits]
  (-> digits string/join (scan-number 2)))

(defn part1-answer [readings]
  (def gamma (-> (map mcb ;readings) to-base10))
  (def epsilon (-> (map lcb ;readings) to-base10))
  (print "The value of gamma is " gamma)
  (print "The value of epsilon is " epsilon)
  (print "The result is " (* gamma epsilon)))

(defn find-value [f readings]
  (defn rf [vals pos]
    (if (one? (length vals))
      vals
      (do
        (def bits (map |($ pos) vals))
        (def fb (f ;bits))
        (filter |(= fb ($ pos)) vals))))
  (def res (reduce rf readings (range (length (first readings)))))
  (to-base10 (first res)))

(defn part2-answer [readings]
  (def o2 (find-value mcb readings))
  (def co2 (find-value lcb readings))
  (print "The oxygen rating is " o2)
  (print "The carbox dioxide rating is " co2)
  (print "The life support rating is " (* o2 co2)))

# Example 1

(def ex-input
  `00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  `)

(def ex-readings (->> (string/trim ex-input)
                      (string/split "\n")
                      (map |(partition 1 $))))

(print "Example 1")
(print "=========")
(part1-answer ex-readings)

# Part 1

(def input (slurp "day03.input"))

(def readings (->> (string/trim input)
                   (string/split "\n")
                   (map | (partition 1 $))))

(print)
(print "Part 1")
(print "======")
(part1-answer readings)

# Example 2

(print)
(print "Example 2")
(print "=========")
(part2-answer ex-readings)

# Part 2
(print)
(print "Part 2")
(print "=========")
(part2-answer readings)
