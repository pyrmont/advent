(def ex-raw
  ```
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (some (* :digits (? "\n")))
               :digits (group (some (number :d)))}
             input))

(defn answer1
  [banks]
  (def res @[])
  (each bank banks
    (def b @"")
    (var skips (- (length bank) 2))
    (var i 0)
    (while (and (< (length b) 2)
                (< i (length bank)))
      (def span (array/slice bank i (+ i skips 1)))
      (def big (max-of span))
      (def pos (index-of big span))
      (buffer/push b (+ big 48))
      (-= skips pos)
      (+= i pos 1))
    (array/push res (scan-number b)))
  (sum res))

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
# (def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day03.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
# (def real-answer2 (answer2 real-input))
