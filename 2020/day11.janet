(import spork/misc :as spork)

(def EMPTY 76)
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

(defn find-equilibrium [plan in-view? tolerance]
  (var curr plan)
  (var prev nil)
  (var take? true)
  (while (not (deep= curr prev))
    (set prev curr)
    (if take?
      (set curr (take-seats curr in-view?))
      (set curr (leave-seats curr in-view? tolerance)))
    (set take? (not take?)))
  curr)

# Example

(def example1-answer
  (->> (find-equilibrium (example 0) false 4)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))

(print "The number of occupied seats is " example1-answer)

(def example2-answer
  (->> (find-equilibrium (example 0) true 5)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))

(print "The number of occupied seats is " example2-answer)

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

(print "The number of occupied seats is " part1-answer)

# # Part 2

(def part2-answer
  (->> (find-equilibrium part1-input true 5)
       (map (fn [row]
              (count (fn [seat] (= seat TAKEN))
                     row)))
       (reduce + 0)))

(print "The number of occupied seats is " part2-answer)
