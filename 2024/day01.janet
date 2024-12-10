# Raw Data

(def ex1-raw
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

# Answers

(def ex1-data (separate ex1-raw))
(def ex1-answer (answer-1 ex1-data))

(def real-data (separate real-raw))
(def real-answer-1 (answer-1 real-data))

# Output

(print "Part 1 is " real-answer-1)
