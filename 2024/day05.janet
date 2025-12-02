# Input

(def ex-raw
  ```
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  ```)

(def real-raw (slurp "day05.input"))

# Functions

(defn interpret [s]
  (peg/match ~{:main (* :pairs :nl :updates)
               :pairs (group (some :pair))
               :pair (group (* :num "|" :num :nl))
               :nl "\n"
               :num (number :d+)
               :updates (group (some :update))
               :update (group (* :num (some (* "," :num)) (? :nl)))}
             s))

(defn make-sort [rules]
  (fn :sortf [a b]
    (when (= a b) (break false))
    (var res false)
    (each [n1 n2] rules
      (cond
        (and (= n1 a) (= n2 b))
        (do
          (set res true)
          (break))
        (and (= n2 a) (= n1 b))
        (do
          (set res false)
          (break))))
    res))

(defn answer-1 [data]
  (def res @[])
  (def [rules updates] data)
  (def before? (make-sort rules))
  (each list updates
    (def correct (sorted list before?))
    (when (deep= list correct)
      (array/push res correct)))
  (reduce (fn [acc x]
            (def i (math/floor (/ (length x) 2)))
            (+ acc (get x i)))
          0
          res))

# Answers

(def ex-data (interpret ex-raw))
(def ex-answer-1 (answer-1 ex-data))

(def real-data (interpret real-raw))
(def real-answer-1 (answer-1 real-data))

# Output

(print "Part 1 is " real-answer-1)
