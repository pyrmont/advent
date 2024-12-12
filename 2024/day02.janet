# Input

(def ex-raw
  ```
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  ```)

(def real-raw (slurp "day02.input"))

# Functions

(defn interpret [s]
  (->> (peg/match ~(some (group (* (some (* (/ ':d+ ,scan-number) (some " ")))
                                   (* (/ ':d+ ,scan-number) (+ "\n" -1)))))
                  s)))

(defn answer-1 [data]
  (var safes 0)
  (each report data
    (when (or (< ;report) (> ;report))
      (var i 1)
      (while (def cur (get report i))
        (def prv (report (dec i)))
        (if (and (not= cur prv)
                 (< 3 (math/abs (- cur prv))))
          (break))
        (++ i))
      (when (= i (length report))
        (++ safes))))
  safes)

# Answers

(def ex-data (interpret ex-raw))
(def ex-answer-1 (answer-1 ex-data))

(def real-data (interpret real-raw))
(def real-answer-1 (answer-1 real-data))

# Output

(print "Part 1 is " real-answer-1)
