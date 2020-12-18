(import spork/misc :as spork)

(defn arrange-l>r [& args]
  (def len (length args))
  (var res (let [xs (take 3 args)]
             [(xs 1) (xs 0) (xs 2)]))
  (var pos 3)
  (while (< pos len)
    (def xs (array/slice args pos (+ 2 pos)))
    (set res [(xs 0) res (xs 1)])
    (+= pos 2))
  res)

(defn arrange-+>* [& args]
  (def len (length args))
  (def res @['* (args 0)])
  (var pos 2)
  (while (< pos len)
    (def opr (args (dec pos)))
    (def opd (args pos))
    (case opr
      '* (array/push res opd)
      '+ (array/push res [opr (array/pop res) opd]))
    (+= pos 2))
  (tuple ;res))

(defn grammar [arrange]
  ~{:main (/ (* :expr (any (* :sp :op :sp :r-expr))) ,arrange)
    :expr (+ (* :l-expr :sp :op :sp :r-expr) :p-expr)
    :l-expr (+ :num :p-expr)
    :r-expr (+ :num :p-expr)
    :p-expr (* "(" :sp :main :sp ")")
    :sp (any " ")
    :op (/ (<- (set "+*")) ,symbol)
    :num (/ (<- :d+) ,scan-number)})

# Example

(def example1
  "1 + 2 * 3 + 4 * 5 + 6")

(def example2
  "1 + (2 * 3) + (4 * (5 + 6))")

(def example1-answer1
  (-> (peg/match (grammar arrange-l>r) example1)
      first
      eval))

(print "The answer is " example1-answer1)

(def example2-answer1
  (-> (peg/match (grammar arrange-l>r) example2)
      first
      eval))

(print "The answer is " example2-answer1)

(def example1-answer2
  (-> (peg/match (grammar arrange-+>*) example1)
      first
      eval))

(print "The answer is " example1-answer2)

(def example2-answer2
  (-> (peg/match (grammar arrange-+>*) example2)
      first
      eval))

(print "The answer is " example2-answer2)

# Part 1

(def part1-input
  (->> (slurp "day18.txt")
       string/trim
       (string/split "\n")))

(def part1-answer
  (->> (map |(-> (peg/match (grammar arrange-l>r) $) first eval) part1-input)
       (reduce + 0)))

(print "The answer is " part1-answer)

# Part 2

(def part2-answer
  (->> (map |(-> (peg/match (grammar arrange-+>*) $) first eval) part1-input)
       (reduce + 0)))

(print "The answer is " part2-answer)
