(ns aoc2019.day1)

(def input (-> (slurp "src/aoc2019/day1.txt")
               (clojure.string/split-lines)))

(def weights (map read-string input))

(defn fuel [n]
  (-> n
    (/ 3)
    (Math/floor)
    (- 2)
    (int)))

(def answer1 (reduce #(+ %1 (fuel %2)) 0 weights))

(defn with-fuel [n]
  (loop [f 0
         w (fuel n)]
    (if (< w 0)
      f
      (recur (+ f w) (fuel w)))))

(def answer2 (reduce #(+ %1 (with-fuel %2)) 0 weights))
