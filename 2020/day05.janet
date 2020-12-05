(defn update-range [dir up down [lo hi]]
  (cond
    (= up dir)
    [(-> (- hi lo) (/ 2) math/ceil (+ lo)) hi]

    (= down dir)
    [lo (-> (- hi lo) (/ 2) math/floor (+ lo))]))

(defn find-row [dirs [lo hi]]
  (var row-range [lo hi])
  (loop [i :range [0 7]
           :let [c (in dirs i)]]
    (set row-range (update-range c 66 70 row-range)))
  (first row-range))

(defn find-col [dirs [lo hi]]
  (var col-range [lo hi])
  (loop [i :range [7 10]
           :let [c (in dirs i)]]
    (set col-range (update-range c 82 76 col-range)))
  (first col-range))

(defn find-details [dirs]
  (let [row (find-row dirs [0 127])
        col (find-col dirs [0 7])
        id  (-> (* row 8) (+ col))]
    [row col id]))

(defn find-seat [ids index]
  (let [seat        (in ids index)
        seat-after  (in ids (inc index))]
    (if (or (nil? seat-after)
            (= (inc seat) seat-after))
      (find-seat ids (inc index))
      (inc seat))))

# Example

(def examples
  ["FBFBBFFRLR"
   "BFFFBBFRRR"
   "FFFBBBFRRR"
   "BBFFBBFRLL"])

(def example-answers
  (map find-details examples))

(printf "Example answers: %j" example-answers)

# Part 1

(def part1-input
  (->> (slurp "day05.txt")
       string/trim
       (string/split "\n")))

(def part1-ids
  (->> (map find-details part1-input)
       (map last)))

(def part1-answer
  (apply max part1-ids))

(print "Highest ID: " part1-answer)

# Part 2

(def part2-answer
  (find-seat (sorted part1-ids) 0))

(print "Seat ID: " part2-answer)
