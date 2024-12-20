# Input

(def ex-raw
  ```
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  ```)

(def real-raw (slurp "day04.input"))

# Functions

(defn interpret [s]
  (peg/match ~(some (+ "\n"
                       -1
                       (/ '(to (+ "\n" -1)) ,string/bytes)))
             s))

(defn check [drct data row col needle pos]
  (def [row* col*]
    (case drct
      :n [(dec row) col]
      :ne [(dec row) (inc col)]
      :e [row (inc col)]
      :se [(inc row) (inc col)]
      :s [(inc row) col]
      :sw [(inc row) (dec col)]
      :w [row (dec col)]
      :nw [(dec row) (dec col)]))
  (when (= (needle pos) (get-in data [row* col*]))
    (if (= (length needle) (inc pos))
      true
      (check drct data row* col* needle (inc pos)))))

(defn answer-1 [data]
  (def needle (string/bytes "XMAS"))
  (var hits 0)
  (for i 0 (length data)
    (def row (data i))
    (for j 0 (length row)
      (when (= (needle 0) (row j))
        (each d [:n :ne :e :se :s :sw :w :nw]
          (if (check d data i j needle 1)
            (++ hits))))))
  hits)

# Answers

(def ex-data (interpret ex-raw))
(def ex-answer-1 (answer-1 ex-data))

(def real-data (interpret real-raw))
(def real-answer-1 (answer-1 real-data))

# Output

(print "Part 1 is " real-answer-1)
