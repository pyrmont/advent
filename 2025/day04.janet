(def ex-raw
  ```
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (some (* :line (? "\n")))
               :line (group (some (+ (* "." (constant nil))
                                     (* "@" (constant :roll)))))}
             input))

(defn mark
  [res row col dir]
  (def [r c] (case dir
               :nw [(dec row) (dec col)]
               :n  [(dec row) col]
               :ne [(dec row) (inc col)]
               :w  [row (dec col)]
               :e  [row (inc col)]
               :sw [(inc row) (dec col)]
               :s  [(inc row) col]
               :se [(inc row) (inc col)]))
  (def max-row (length res))
  (def max-col (length (first res)))
  (when (and (< -1 r max-row)
             (< -1 c max-col))
    (def coords [r c])
    (def prev (get-in res coords 0))
    (put-in res coords (inc prev))))

(defn count-up
  [grid]
  (def res @[])
  (each row grid
    (array/push res (array/new-filled (length row) 0)))
  (var i 0)
  (while (def row (get grid i))
    (var j 0)
    (while (< j (length row))
      (when (get row j)
        (mark res i j :nw)
        (mark res i j :n)
        (mark res i j :ne)
        (mark res i j :w)
        (mark res i j :e)
        (mark res i j :sw)
        (mark res i j :s)
        (mark res i j :se))
      (++ j))
    (++ i))
  res)

(defn answer1
  [grid]
  (var total 0)
  (def counts (count-up grid))
  (var i 0)
  (while (def row (get grid i))
    (var j 0)
    (while (< j (length row))
      (when (get row j)
        (when (< (get-in counts [i j]) 4)
          (++ total)))
      (++ j))
    (++ i))
  total)

(defn answer2
  [original-grid]
  (var total 0)
  (def grid @[])
  (each row original-grid
    (array/push grid (array/slice row)))
  (var prev nil)
  (while (not= total prev)
    (set prev total)
    (def counts (count-up grid))
    (var i 0)
    (while (def row (get grid i))
      (var j 0)
      (while (< j (length row))
        (when (get row j)
          (when (< (get-in counts [i j]) 4)
            (put-in grid [i j] nil)
            (++ total)))
        (++ j))
      (++ i)))
  total)

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
(def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day04.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
(def real-answer2 (answer2 real-input))
