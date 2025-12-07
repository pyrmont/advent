(def ex-raw
  ```
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (* :ranges "\n" :ingredients)
               :ranges (group (some (* :range (? "\n"))))
               :range (group (* (number :d+) "-" (number :d+)))
               :ingredients (group (some (* (number :d+) (? "\n"))))}
             input))

(defn answer1
  [[ranges ingredients]]
  (def res @[])
  (each ing ingredients
    (each [beg end] ranges
      (when (<= beg ing end)
        (array/push res ing)
        (break))))
  (length res))

(defn answer2
  [[ranges _]]
  (def ordered (sorted ranges (fn [a b] (< (first a) (first b)))))
  (def merged @[])
  (var c-beg nil)
  (var c-end nil)
  (each [beg end] ordered
    (if (nil? c-beg)
      (do
        (set c-beg beg)
        (set c-end end))
      (if (<= beg (inc c-end))
        (set c-end (max c-end end))
        (do
          (array/push merged [c-beg c-end])
          (set c-beg beg)
          (set c-end end)))))
  (when (not (nil? c-beg))
    (array/push merged [c-beg c-end]))
  (var res 0)
  (each [beg end] merged
    (+= res (inc (- end beg))))
  res)

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
(def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day05.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
(def real-answer2 (answer2 real-input))
