(import spork/misc :as spork)

(def ACTIVE 35)

(defn create-initial-state-3D [input]
  (def result @{})
  (def x-len (dec (length (first input))))
  (def y-len (dec (length input)))
  (def z-len 0)
  (loop [z :range-to [0 z-len]
         y :range-to [0 y-len]
         x :range-to [0 x-len]
           :when (= ACTIVE (get-in input [y x]))]
    (put result [x y z] (get-in input [y x])))
  result)

(defn make-active-3D? [coords state]
  (def [x y z] coords)
  (var active-neighbours 0)
  (loop [i :range-to [-1 1]
         j :range-to [-1 1]
         k :range-to [-1 1]
           :let [x* (+ x i)
                 y* (+ y j)
                 z* (+ z k)]]
    (when (and (not= 0 i j k)
               (= ACTIVE (state [x* y* z*])))
      (++ active-neighbours)))
  (if (= ACTIVE (state coords))
    (if (<= 2 active-neighbours 3)
      true
      false)
    (if (= 3 active-neighbours)
      true
      false)))

(defn simulate-3D [state cache cycle stop]
  (if (= cycle stop)
    state
    (do
      (def new-state @{})
      (loop [[[x y z] val] :pairs state]
        (loop [i :range-to [-1 1]
               j :range-to [-1 1]
               k :range-to [-1 1]
                 :let [x* (+ x i)
                       y* (+ y j)
                       z* (+ z k)
                       coords [x* y* z*]]]
          (when (and (nil? (cache coords))
                     (or (= 0 i j k)
                         (not= ACTIVE (state coords))))
            (if (make-active-3D? coords state)
              (put new-state coords ACTIVE)
              (put cache coords true)))))
      (simulate-3D new-state @{} (inc cycle) stop))))

(defn create-initial-state-4D [input]
  (def result @{})
  (def x-len (dec (length (first input))))
  (def y-len (dec (length input)))
  (def z-len 0)
  (def w-len 0)
  (loop [w :range-to [0 w-len]
         z :range-to [0 z-len]
         y :range-to [0 y-len]
         x :range-to [0 x-len]
           :when (= ACTIVE (get-in input [y x]))]
    (put result [x y z w] (get-in input [y x])))
  result)

(defn make-active-4D? [coords state]
  (def [x y z w] coords)
  (var active-neighbours 0)
  (loop [i :range-to [-1 1]
         j :range-to [-1 1]
         k :range-to [-1 1]
         l :range-to [-1 1]
           :let [x* (+ x i)
                 y* (+ y j)
                 z* (+ z k)
                 w* (+ w l)]]
    (when (and (not= 0 i j k l)
               (= ACTIVE (state [x* y* z* w*])))
      (++ active-neighbours)))
  (if (= ACTIVE (state coords))
    (if (<= 2 active-neighbours 3)
      true
      false)
    (if (= 3 active-neighbours)
      true
      false)))

(defn simulate-4D [state cache cycle stop]
  (if (= cycle stop)
    state
    (do
      (def new-state @{})
      (loop [[[x y z w] val] :pairs state]
        (loop [i :range-to [-1 1]
               j :range-to [-1 1]
               k :range-to [-1 1]
               l :range-to [-1 1]
                 :let [x* (+ x i)
                       y* (+ y j)
                       z* (+ z k)
                       w* (+ w l)
                       coords [x* y* z* w*]]]
          (when (and (nil? (cache coords))
                     (or (= 0 i j k l)
                         (not= ACTIVE (state coords))))
            (if (make-active-4D? coords state)
              (put new-state coords ACTIVE)
              (put cache coords true)))))
      (simulate-4D new-state @{} (inc cycle) stop))))

# Example

(def example
  (->>
    ```
    .#.
    ..#
    ###
    ```
    spork/dedent
    (string/split "\n")))

(def example-answer1
  (-> (create-initial-state-3D example)
      (simulate-3D @{} 0 6)
      values
      length))

(print "The number of cubes active after 6 cycles is " example-answer1)

# Part 1

(def part1-input
  (->> (slurp "day17.txt")
       string/trim
       (string/split "\n")))

(def part1-answer
  (-> (create-initial-state-3D part1-input)
      (simulate-3D @{} 0 6)
      values
      length))

(print "The number of cubes active after 6 cycles is " part1-answer)

# Part 2

(def example-answer2
  (-> (create-initial-state-4D example)
      (simulate-4D @{} 0 6)
      values
      length))

(print "The number of hypercubes active after 6 cycles is " example-answer2)

(def part2-answer
  (-> (create-initial-state-4D part1-input)
      (simulate-4D @{} 0 6)
      values
      length))

(print "The number of hypercubes active after 6 cycles is " part2-answer)
