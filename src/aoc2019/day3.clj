(ns aoc2019.day3
  (:require [clojure.string]
            [clojure.set]))

(def the-input (-> (slurp "src/aoc2019/day3.txt")
                   (clojure.string/trim-newline)
                   (clojure.string/split-lines)))

(def the-paths (->> the-input
                    (map #(clojure.string/split % #","))
                    (map #(map (fn [w] (clojure.string/split w #"" 2)) %))))

(defn move [dir [x y]]
  (case dir
    "U" [x (+ y 1)]
    "D" [x (- y 1)]
    "L" [(- x 1) y]
    "R" [(+ x 1) y]))

(defn trace [path plane start]
  (let [[dir times] (first path)
        remainder (rest path)
        points (drop 1 (take (+ 1 (read-string times)) (iterate (partial move dir) start)))
        new-plane (reduce #(conj %1 %2) plane points)]
    (if (empty? remainder)
      new-plane
      (recur remainder new-plane (last points)))))

(defn m-dist [[x y]]
  (+ (Math/abs x) (Math/abs y)))

(defn shortest-m-dist [points]
  (apply min (map m-dist points)))

(def origin [0 0])

(def the-plane (map #(trace % [origin] origin) the-paths))

(def the-points (as-> the-plane v
                      (map #(set %) v)
                      (apply clojure.set/intersection v)
                      (disj v [0 0])))

(def answer1 (shortest-m-dist the-points))

(defn p-dist [point line]
  (.indexOf line point))

(defn shortest-p-dist [points plane]
    (->> (map (fn [line] (map (fn [point] (p-dist point line)) points)) plane)
         (apply interleave)
         (partition 2)
         (map #(reduce + %))
         (apply min)))

(def answer2 (shortest-p-dist the-points the-plane))
