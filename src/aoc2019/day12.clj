(ns aoc2019.day12
  (:require [clojure.string]
            [clojure.math.combinatorics :as combine]
            [clojure.math.numeric-tower :as math]))

(def the-input (-> (slurp "src/aoc2019/day12.txt")
                   (clojure.string/trim-newline)))

(def the-moons (->> (clojure.string/split-lines the-input)
                    (map #(re-seq #"-?\d+" %))
                    (map #(map (fn [x] (Integer/parseInt x)) %))
                    (map #(zipmap [:x :y :z] %))))

(defn get-all-pairs [moons]
  (combine/combinations moons 2))

(defn g-force [p1 p2]
  (cond
    (< p1 p2) [1 -1]
    (> p1 p2) [-1 1]
    (= p1 p2) [0 0]))

(defn calculate-g-force [pair]
  (let [[m1 m2] pair
        [x1 x2] (g-force (:x m1) (:x m2))
        [y1 y2] (g-force (:y m1) (:y m2))
        [z1 z2] (g-force (:z m1) (:z m2))]
    [[x1 y1 z1] [x2 y2 z2]]))

(defn calculate-g-forces [pairs]
  (reduce (fn [effects pair]
            (let [[m1 m2] pair
                  [e1 e2] (calculate-g-force pair)]
              (assoc effects m1 (map + (get effects m1 [0 0 0]) e1)
                             m2 (map + (get effects m2 [0 0 0]) e2))))
          {}
          pairs))

(defn starting-positions [moons]
  (reduce #(assoc %1 %2 [0 0 0]) {} moons))

(def t1-moons
  [{:x -1 :y 0 :z 2}
   {:x 2 :y -10 :z -7}
   {:x 4 :y -8 :z 8}
   {:x 3 :y 5 :z -1}])

(def t1-pairs (get-all-pairs t1-moons))
(def t1-effects (calculate-g-forces t1-pairs))
(def t1-velocities (starting-positions t1-moons))

(defn step [moons effects velocities]
  (reduce (fn [system moon]
            (let [old-pos [(:x moon) (:y moon) (:z moon)]
                  new-pos (map + old-pos (get effects moon) (get velocities moon))]
              (assoc system (zipmap [:x :y :z] new-pos) (map - new-pos old-pos))))
          {}
          moons))

(defn simulate [moons steps]
  (loop [velocities (starting-positions moons)
         steps steps]
    (let [moons (keys velocities)
          pairs (get-all-pairs moons)
          effects (calculate-g-forces pairs)]
      (if (= 0 steps)
        velocities
        (recur (step moons effects velocities) (dec steps))))))

(defn total-energy [system]
  (reduce (fn [total [pos vel]]
            (+ total
               (* (reduce + (map math/abs (vals pos)))
                  (reduce + (map math/abs vel)))))
          0
          system))

(def answer1 (-> (simulate the-moons 1000)
                 (total-energy)))
