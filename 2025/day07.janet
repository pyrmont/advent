(def ex-raw
  ```
  .......S.......
  ...............
  .......^.......
  ...............
  ......^.^......
  ...............
  .....^.^.^.....
  ...............
  ....^.^...^....
  ...............
  ...^.^...^.^...
  ...............
  ..^...^.....^..
  ...............
  .^.^.^.^.^...^.
  ...............
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (/ (* :first :rows :count) ,struct)
               :count (* (constant :lines) (line))
               :first (* (some (+ :empty :entry)) (? :nl))
               :empty "."
               :entry (* (constant :entry) (group (* (line) (column) "S")))
               :rows (* (constant :splitters) (group (some :row)))
               :row (* (some (+ :empty :splitter)) (? :nl))
               :splitter (group (* (line) (column) "^"))
               :nl "\n"}
             input))

(defn answer1
  [input]
  (def diagram (first input))
  (var splits 0)
  (def beams @[(diagram :entry)])
  (def splitters (diagram :splitters))
  (loop [i :range-to [1 (diagram :lines)]]
    (def new-beams @[])
    (each b beams
      (def row (get b 0))
      (def col (get b 1))
      (def hit (find (fn [x] (and (= row (get x 0)) (= col (get x 1)))) splitters))
      (if hit
        (do
          (++ splits)
          (array/push new-beams [(inc i) (dec col)] [(inc i) (inc col)]))
        (array/push new-beams [(inc row) col])))
    (array/clear beams)
    (each b new-beams
      (unless (find (fn [x] (= (get b 1) (get x 1))) beams)
        (array/push beams b))))
  splits)

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))

(def real-raw (slurp "day07.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
