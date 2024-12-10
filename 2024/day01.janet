# Input

(def ex-raw
  ```
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  ```)

(def real-raw (slurp "day01.input"))

# Functions

(defn distribute [n ind]
  (def res @[])
  (loop [i :range [0 n]]
    (array/push res @[]))
  (var i 0)
  (while (def v (get ind i))
    (def which (mod i n))
    (array/push (get res which) v)
    (++ i))
  res)

(defn separate [s]
  (->> (peg/match ~(some (* (/ ':d+ ,scan-number) :s+ (/ ':d+ ,scan-number) (+ "\n" -1))) s)
       (distribute 2)))

(defn answer-1 [data]
  (def ind-a (sort (get data 0)))
  (def ind-b (sort (get data 1)))
  (->> (interleave ind-a ind-b)
       (partition 2)
       (reduce (fn [acc [a b]]
                    (+ acc (math/abs (- a b))))
               0)))

(defn answer-2 [data]
  (def list-1 (get data 0))
  (def counts-2 (frequencies (get data 1)))
  (reduce (fn [acc i]
            (+ acc (* i (or (counts-2 i) 0))))
          0
          list-1))

# Answers

(def ex-data (separate ex-raw))
(def ex-answer-1 (answer-1 ex-data))
(def ex-answer-2 (answer-2 ex-data))

(def real-data (separate real-raw))
(def real-answer-1 (answer-1 real-data))
(def real-answer-2 (answer-2 real-data))

# Output

(print "Part 1 is " real-answer-1)
(print "Part 2 is " real-answer-2)
