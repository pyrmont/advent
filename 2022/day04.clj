(ns day04
  (:require [clojure.set :refer [intersection subset?]]
            [clojure.string :refer [split]]
            [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Example Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input
  "
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  ")

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(defn line->sets [line]
  (->> (split line #"[-,]")
       (map #(Integer/parseInt %))
       (partition 2)
       (map (fn [[start end]] (range start (inc end))))
       (map set)))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(defn fully-contains? [line]
  (->> (line->sets line)
       (sort #(< (count %1) (count %2)))
       (apply subset?)))

(defn part1 [lines]
  (count (filter fully-contains? lines)))

;; Example

(part1 (util/trim-split eg-input 2)) ; 2

;; Answer

(part1 (util/trim-split (slurp "day04.input"))) ; 582

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(defn partly-contains? [line]
  (->> (line->sets line)
       (apply intersection)
       (empty?)
       (not)))

(defn part2 [lines]
  (count (filter partly-contains? lines)))

;; Example

(part2 (util/trim-split eg-input 2)) ; 4

;; Answer

(part2 (util/trim-split (slurp "day04.input"))) ; 893
