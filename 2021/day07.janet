# Input

(def ex-input "16,1,2,0,4,2,7,1,2,14")

(def input (-> (slurp "day07.input") string/trim))

# Parser

(defn crabs [input]
  (->> (string/split "," input) (map scan-number)))

# Functions

(defn fuel-used [start end]
  (def w (math/abs (- start end)))
  (/ (* w (+ w 1)) 2))

(defn middle [points]
  (get points (/ (length points) 2)))

(defn total-fuel [origin points]
  (->> (map |(fuel-used $ origin) points)
       (reduce + 0)))

(defn find-least-fuel [points]
  (def start (middle points))
  (def total (total-fuel start points))
  (def above (total-fuel (inc start) points))
  (def below (total-fuel (dec start) points))
  (if (< below start above)
    total
    (do
      (def adjust (if (< start below) inc dec))
      (var last-start (adjust start))
      (var last-total (if (< start below) above below))
      (var keep-adjusting? true)
      (while keep-adjusting?
        (def start (adjust last-start))
        (def total (total-fuel start points))
        (if (< total last-total)
          (do
            (set last-start start)
            (set last-total total))
          (set keep-adjusting? false)))
      last-total)))

# Answers

(defn answer [input]
  (def c (sort (crabs input)))
  (def m (middle c))
  (reduce |(+ $0 (math/abs (- $1 m))) 0 c))

(defn answer2 [input]
  (find-least-fuel (sort (crabs input))))

(print "The part 1 answer for the example input is " (answer ex-input))

(print "The part 1 answer for the input is " (answer input))

(print "The part 2 answer for the example input is " (answer2 ex-input))

(print "The part 2 answer for the input is " (answer2 input))
