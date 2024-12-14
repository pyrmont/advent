# Input

(def ex-raw-1
  `xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))`)

(def ex-raw-2
  `xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))`)

(def real-raw (slurp "day03.input"))

# Functions

(defn interpret-1 [s]
  (peg/match ~(some (+ (group (* "mul("
                                 (/ ':d+ ,scan-number)
                                 ","
                                 (/ ':d+ ,scan-number)
                                 ")"))
                       1
                       -1))
             s))

(defn interpret-2 [s]
  (peg/match ~(some (+ (group (* "mul("
                                 (/ ':d+ ,scan-number)
                                 ","
                                 (/ ':d+ ,scan-number)
                                 ")"))
                       '"don't"
                       '"do"
                       1
                       -1))
             s))

(defn answer-1 [data]
  (reduce (fn [acc [x y]]
            (+ acc (* x y)))
          0
          data))

(defn answer-2 [data]
  (var enabled? true)
  (reduce (fn [acc el]
            (case el
              "don't"
              (do
                (set enabled? false)
                acc)

              "do"
              (do
                (set enabled? true)
                acc)

              (if enabled?
                (+ acc (* (el 0) (el 1)))
                acc)))
          0
          data))

# Answers

(def ex-data-1 (interpret-1 ex-raw-1))
(def ex-answer-1 (answer-1 ex-data-1))
(def ex-data-2 (interpret-2 ex-raw-2))
(def ex-answer-2 (answer-2 ex-data-2))

(def real-data-1 (interpret-1 real-raw))
(def real-answer-1 (answer-1 real-data-1))
(def real-data-2 (interpret-2 real-raw))
(def real-answer-2 (answer-2 real-data-2))

# Output

(print "Part 1 is " real-answer-1)
(print "Part 2 is " real-answer-2)
