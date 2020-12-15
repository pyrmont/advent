(defn start-sequence [numbers]
  (def history @[nil])
  (def last-spoken @{})
  (loop [i :range [0 (length numbers)]
           :let [number (numbers i)]]
    (array/push history number)
    (put last-spoken number (inc i)))
  [history last-spoken])

(defn speak [not-start turn stop history last-spoken]
  (def current (last history))
  (if (= turn stop)
    history
    (do
      (if-let [last-turn (and not-start (last-spoken current))]
        (array/push history (- turn last-turn))
        (array/push history 0))
      (put last-spoken current turn)
     (speak true (inc turn) stop history last-spoken))))

(defn find-number [numbers target]
  (->> (start-sequence numbers)
       (apply (partial speak false (length numbers) target))
       last))

# Example

(def example
  (->> "0,3,6"
       (string/split ",")
       (map scan-number)))

(def example-answer1
  (find-number example 2020))

(print "The 2020th number is " example-answer1)

(def example-answer2
  (find-number example 30000000))

(print "The 30000000th number is " example-answer2)
# Part 1

(def part1-input
  (->> (slurp "day15.txt")
       string/trim
       (string/split ",")
       (map scan-number)))

(def part1-answer
  (find-number part1-input 2020))

(print "The 2020th number is " part1-answer)

# Part 2

(def part2-answer
  (find-number part1-input 30000000))

(print "The 30000000th number is " part2-answer)
