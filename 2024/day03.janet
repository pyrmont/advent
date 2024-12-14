# Input

(def ex-raw
  `xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))`)

(def real-raw (slurp "day03.input"))

# Functions

(defn interpret [s]
  (peg/match ~(some (+ (group (* "mul("
                                 (/ ':d+ ,scan-number)
                                 ","
                                 (/ ':d+ ,scan-number)
                                 ")"))
                       1
                       -1))
             s))

(defn answer-1 [data]
  (reduce (fn [acc [x y]]
            (+ acc (* x y)))
          0
          data))

# Answers

(def ex-data (interpret ex-raw))
(def ex-answer-1 (answer-1 ex-data))

(def real-data (interpret real-raw))
(def real-answer-1 (answer-1 real-data))

# Output

(print "Part 1 is " real-answer-1)
