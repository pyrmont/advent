(ns aoc2019.day6
  (:require [clojure.set]
            [clojure.string]
            [clojure.zip]))

(defn build-input [s]
  (-> (clojure.string/trim-newline s)
      (clojure.string/split-lines)))

(def the-input (build-input (slurp "src/aoc2019/day6.txt")))

(defn add-to-orbits [orbits [a b]]
  (if-let [ds (get orbits a)]
    (assoc orbits a (conj ds b))
    (assoc orbits a (list b))))

(defn build-orbit-table [input]
  (reduce (fn [m v] (->> (clojure.string/split v #"\)")
                         (add-to-orbits m)))
          {}
          input))

(def the-orbit-table (build-orbit-table the-input))

(defn build-graph [orbit-table start]
  (let [orbiters (get orbit-table start)]
    (cons start (reduce #(cons (build-graph orbit-table %2) %1) () orbiters))))

(def the-orbits (build-graph the-orbit-table "COM"))

(declare calc-orbits)

(defn tally-or-recur [value tally]
  (if (string? value)
    tally
    (calc-orbits value (inc tally))))

(defn calc-orbits
  ([graph]
   (calc-orbits graph 0))
  ([graph num-orbits]
   (reduce #(+ %1 (tally-or-recur %2 num-orbits)) 0 graph)))

(def answer1 (calc-orbits the-orbits))

(defn get-parents [zip]
  (map first (clojure.zip/path zip)))

(defn find-path-to-node [graph text]
  (let [zip (clojure.zip/seq-zip graph)]
    (loop [loc (clojure.zip/next zip)]
      (cond
        (clojure.zip/end? loc) nil
        (= text (clojure.zip/node loc)) (get-parents loc)
        :else (recur (clojure.zip/next loc))))))

(defn disjunct [n1 n2]
  (let [s1 (set n1) s2 (set n2)]
    (clojure.set/difference (clojure.set/union s1 s2) (clojure.set/intersection s1 s2))))

(defn min-num-orbit-transfers [graph s1 s2]
  (let [p1 (find-path-to-node graph s1)
        p2 (find-path-to-node graph s2)]
    (count (disjunct (set p1) (set p2)))))

(def answer2 (- (min-num-orbit-transfers the-orbits "YOU" "SAN") 2))
