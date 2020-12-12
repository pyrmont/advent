(import spork/misc :as spork)

(def grammar
  ~{:main (some (* :dir :dist (? :nl)))
    :dir (/ (<- (set "NSEWFLR")) ,keyword)
    :dist (/ (<- (* (? "-") :d+)) ,scan-number)
    :nl "\n"})

(defn move-in-dir [coords dir dist]
  (def [x y] coords)
  (case dir
    :N [x (+ y dist)]
    :S [x (- y dist)]
    :E [(+ x dist) y]
    :W [(- x dist) y]))

(defn turn-ship [ort deg]
  (def turns (% (/ deg 90) 4))
  (def about {:N :S :E :W :S :N :W :E})
  (def right {:N :E :E :S :S :W :W :N})
  (def left  {:N :W :W :S :S :E :E :N})
  (case turns
    +0 ort
    -0 ort
    +1 (right ort)
    -1 (left ort)
    +2 (about ort)
    -2 (about ort)
    +3 (left ort)
    -3 (right ort)))

(defn execute-without-waypoint [steps ort]
  (var coords [0 0])
  (var curr-ort ort)
  (each [dir num] (partition 2 steps)
    (case dir
      :F (set coords (move-in-dir coords curr-ort num))
      :L (set curr-ort (turn-ship curr-ort (* -1 num)))
      :R (set curr-ort (turn-ship curr-ort num))
      (set coords (move-in-dir coords dir num))))
  [coords curr-ort])

(defn move-with-waypoint [coords waypoint num]
  (def [coord-x coord-y] coords)
  (def [wp-x wp-y] waypoint)
  [(+ coord-x (* wp-x num)) (+ coord-y (* wp-y num))])

(defn move-waypoint [waypoint dir num]
  (def [x y] waypoint)
  (case dir
    :N [x (+ y num)]
    :S [x (- y num)]
    :E [(+ x num) y]
    :W [(- x num) y]))

(defn rotate-waypoint [waypoint deg]
  (def quarter-revs (% (/ deg 90) 4))
  (def [x y] waypoint)
  (case quarter-revs
    +0 waypoint
    -0 waypoint
    +1 [y (* -1 x)]
    -1 [(* -1 y) x]
    +2 [(* -1 x) (* -1 y)]
    -2 [(* -1 x) (* -1 y)]
    +3 [(* -1 y) x]
    -3 [y (* -1 x)]))

(defn execute-with-waypoint [steps]
  (var coords [0 0])
  (var waypoint [10 1])
  (each [dir num] (partition 2 steps)
    (case dir
      :F (set coords (move-with-waypoint coords waypoint num))
      :L (set waypoint (rotate-waypoint waypoint (* -1 num)))
      :R (set waypoint (rotate-waypoint waypoint num))
      (set waypoint (move-waypoint waypoint dir num))))
  coords)

(defn calc-manhattan [coords]
  (def [x y] coords)
  (+ (math/abs x) (math/abs y)))

# Example

(def example
  (->>
    ```
    F10
    N3
    F7
    R90
    F11
    ```
    spork/dedent
    (peg/match grammar)))

(def example-answer1
  (-> (execute-without-waypoint example :E)
      first
      calc-manhattan))

(print "The Manhattan distance is " example-answer1)

(def example-answer2
  (-> (execute-with-waypoint example)
      calc-manhattan))

(print "The Manhattan distance is " example-answer2)

# Part 1

(def part1-input
  (->> (slurp "day12.txt")
       string/trim
       (peg/match grammar)))

(def part1-answer
  (-> (execute-without-waypoint part1-input :E)
      first
      calc-manhattan))

(print "The Manhattan distaince is " part1-answer)

# Part 2

(def part2-answer
  (-> (execute-with-waypoint part1-input)
      calc-manhattan))

(print "The Manhattan distance is " part2-answer)
