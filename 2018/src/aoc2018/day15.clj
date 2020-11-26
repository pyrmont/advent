(ns aoc2018.day15
  (:require [clojure.string]))

(def the-input (-> (slurp "src/aoc2018/day15.txt")
                   (clojure.string/split-lines)))

(def the-world (clojure.string/join the-input))

(defn character [world pos]
  (case (get world pos)
    \E \E
    \G \G
    nil))

(defn characters [world]
  (let [len (count world)]
    (loop [pos 0
           cs []]
      (if (< pos len)
        (recur (+ 1 pos) (if-let [c (character world pos)]
                           (conj cs [c pos])
                           cs))
        cs))))

(defn nearest-enemy [world cs c]
  )
