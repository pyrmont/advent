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

(defn answer1
  [grid]
  (def counts @[])
  (each row grid
    (array/push counts (array/new-filled (length row) 0)))
  (var i 0)
  (while (def row (get grid i))
    (var j 0)
    (while (< j (length row))
      (when (get row j)
        (mark counts i j :nw)
        (mark counts i j :n)
        (mark counts i j :ne)
        (mark counts i j :w)
        (mark counts i j :e)
        (mark counts i j :sw)
        (mark counts i j :s)
        (mark counts i j :se))
      (++ j))
    (++ i))
  (set i 0)
  (var total 0)
  (while (def row (get grid i))
    (var j 0)
    (while (< j (length row))
      (when (get row j)
        (when (< (get-in counts [i j]) 4)
          (++ total)))
      (++ j))
    (++ i))
  total)

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
# (def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day04.input"))
#
(def real-input (interpret real-raw))
# (def real-answer1 (answer1 real-input))
# (def real-answer2 (answer2 real-input))
