# Input

(def ex-input
  ```
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  ```)

(def input (-> (slurp "day05.input") string/trim))

# Parser

(def g (peg/compile
  ~{:main   (* :line (any (* :s+ :line)))
    :line   (group (* :coords " -> " :coords))
    :coords (group (* (/ ':d+ ,scan-number) "," (/ ':d+ ,scan-number)))}))

(defn lines [input]
  (peg/match g input))

(defn hv-lines [lines]
  (filter
    (fn [[[x1 y1] [x2 y2]]]
      (or (= x1 x2) (= y1 y2)))
    lines))

(defn interpolate [[a1 b1] [a2 b2]]
  (def res @[])
  (def step (if (< a1 a2) 1 -1))
  (var ai a1)
  (while (not (= (- ai step) a2))
    (def bi (+ b1 (* (/ (- ai a1) (- a2 a1)) (- b2 b1))))
    (array/push res [(string ai) (string bi)]) # necessary to avoid rounding issues
    (set ai (+ ai step)))
  res)

(defn plot [lines]
  (def points @{})
  (each line lines
    (def [[x1 y1] [x2 y2]] line)
    (if (= x1 x2)
      (each [yi xi] (interpolate [y1 x1] [y2 x2])
        (->> (get points [xi yi] 0) inc (put points [xi yi])))
      (each [xi yi] (interpolate [x1 y1] [x2 y2])
        (->> (get points [xi yi] 0) inc (put points [xi yi])))))
  points)

# Answer

(defn answer [input perpendicular?]
  (def filter-lines (if perpendicular? hv-lines identity))
  (def points (-> (lines input) filter-lines plot))
  (reduce |(+ $0 (if (> $1 1) 1 0)) 0 points))

(print "Perpendicular lines overlap in the example input " (answer ex-input true) " times")
(print "Perpendicular lines overlap in the input " (answer input true) " times")

(print "Lines overlap in the example input " (answer ex-input false) " times")
(print "Lines overlap in the input " (answer input false) " times")
