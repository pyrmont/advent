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

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
# (def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day05.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
# (def real-answer2 (answer2 real-input))
