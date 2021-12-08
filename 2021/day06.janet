# Input

(def ex-input "3,4,3,1,2")

(def input (-> (slurp "day06.input") string/trim))

# Parser

(defn fishes [input]
  (->>  (string/split "," input) (map scan-number)))

# Functions

(defn group [initial-fishes]
  (def res (array/new-filled 9 0))
  (each fish initial-fishes
    (->> (get res fish) inc (put res fish)))
  res)

(defn simulate [initial-fishes last-day]
  (def fishes initial-fishes)
  (var day 1)
  (while (<= day last-day)
    (def num-fishes (length fishes))
    (var i 0)
    (while (< i num-fishes)
      (if (zero? (fishes i))
        (do
          (put fishes i 6)
          (array/push fishes 8))
        (put fishes i (dec (fishes i))))
      (++ i))
    (++ day))
  fishes)

(defn tally-per-day [initial-fishes last-day]
  (var counts (group initial-fishes))
  (loop [day :range-to [1 last-day]]
    (def new-counts (array/new-filled 9 0))
    (loop [i :range-to [0 8]]
      (def curr-count (counts i))
      (case i
        0 (do
            (put new-counts 6 curr-count)
            (put new-counts 8 curr-count))
        7 (put new-counts 6 (+ curr-count (new-counts 6)))
        (put new-counts (dec i) curr-count)))
    (set counts new-counts))
  counts)

# Answers

(defn slow-answer [input days]
  (-> (fishes input) (simulate days) length))

(defn fast-answer [input days]
  (def population (-> (fishes input) (tally-per-day days)))
  (reduce + 0 population))

(print "The number of example fish after 18 days is " (slow-answer ex-input 18))
(print "The number of example fish after 80 days is " (slow-answer ex-input 80))
(print "The number of fish after 80 days is " (slow-answer input 80))

(print "The number of example fish after 256 days is " (fast-answer ex-input 256))
(print "The number of fish after 256 days is " (fast-answer input 256))
