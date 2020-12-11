(import spork/misc :as spork)

(def NL 10)
(def EMPTY 76)
(def FLOOR 46)
(def TAKEN 35)

(def example
  (->> (slurp "day11-examples.txt")
       string/trim
       (string/split "\n\n")
       (map |(->> (string/split "\n" $)
                  (map buffer)))))

(defn seat-in-dir [plan row col row-f col-f]
  (var row-look (row-f row))
  (var col-look (col-f col))
  (var seat (get-in plan [row-look col-look]))
  (var stop? (or (nil? seat)
                 (= seat TAKEN)
                 (= seat EMPTY)))
  (while (not stop?)
    (set row-look (row-f row-look))
    (set col-look (col-f col-look))
    (set seat (get-in plan [row-look col-look]))
    (set stop? (or (nil? seat)
                   (= seat TAKEN)
                   (= seat EMPTY))))
  seat)

(defn visible-seats [plan row col]
  [(seat-in-dir plan row col dec dec)
   (seat-in-dir plan row col dec identity)
   (seat-in-dir plan row col dec inc)
   (seat-in-dir plan row col identity dec)
   (seat-in-dir plan row col identity inc)
   (seat-in-dir plan row col inc dec)
   (seat-in-dir plan row col inc identity)
   (seat-in-dir plan row col inc inc)])

(defn surrounding-seats [plan row col]
  [(get-in plan [(dec row) (dec col)])
   (get-in plan [(dec row) col])
   (get-in plan [(dec row) (inc col)])
   (get-in plan [row (dec col)])
   (get-in plan [row (inc col)])
   (get-in plan [(inc row) (dec col)])
   (get-in plan [(inc row) col])
   (get-in plan [(inc row) (inc col)])])

(defn too-many-people? [in-view? plan row col max-num]
  (let [f (if in-view? visible-seats surrounding-seats)]
    (>= (count |(= $ TAKEN) (f plan row col)) max-num)))

(defn take-seats [plan in-view?]
  (def row-length (length plan))
  (def col-length (length (plan 0)))
  (def res (array/new row-length))
  (loop [row :range [0 row-length]
         col :range [0 col-length]
             :let [seat (get-in plan [row col])]]
    (when (zero? col)
      (array/push res (buffer/new col-length)))
    (if (and (= EMPTY seat)
             (not (too-many-people? in-view? plan row col 1)))
      (put-in res [row col] TAKEN)
      (put-in res [row col] seat)))
  res)

(defn leave-seats [plan in-view? tolerance]
  (def row-length (length plan))
  (def col-length (length (plan 0)))
  (def res (array/new row-length))
  (loop [row :range [0 row-length]
         col :range [0 col-length]
             :let [seat (get-in plan [row col])]]
    (when (zero? col)
      (array/push res (buffer/new col-length)))
    (if (and (= TAKEN seat)
             (too-many-people? in-view? plan row col tolerance))
      (put-in res [row col] EMPTY)
      (put-in res [row col] seat)))
  res)

# (defn simulate-selection [plan steps]
#   (var res plan)
#   (loop [i :range [0 steps]]
#     (case (% i 2)
#       0 (set res (take-seats res))
#       1 (set res (leave-seats res))))
#   res)

# (def step1 (take-seats (example 0)))
# (deep= step1 (example 1))
# (def step2 (leave-seats step1))
# (deep= step2 (example 2))
# (def step3 (take-seats step2))
# (deep= step3 (example 3))

# (def step1 (simulate-selection (example 0) 1))
# (deep= step1 (example 1))
# (def step2 (simulate-selection (example 0) 2))
# (deep= step2 (example 2))
# (def step3 (simulate-selection (example 0) 3))
# (deep= step3 (example 3))
# (def step4 (simulate-selection (example 0) 4))
# (deep= step4 (example 4))

(defn find-equilibrium [plan in-view? tolerance]
  (var curr plan)
  (var prev nil)
  (var i 0)
  (while (not (deep= curr prev))
    (set prev curr)
    (if (zero? (% i 2))
      (set curr (take-seats curr in-view?))
      (set curr (leave-seats curr in-view? tolerance)))
    (++ i))
  curr)

(def example-answer
  (->> (find-equilibrium (example 0) false 4)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))

(def example2-answer
  (->> (find-equilibrium (example 0) true 5)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))

# Part 1

(def part1-input
  (->> (slurp "day11.txt")
       string/trim
       (string/split "\n")
       (map buffer)))

(def part1-answer
  (->> (find-equilibrium part1-input false 4)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))

(def part2-answer
  (->> (find-equilibrium part1-input true 5)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))
