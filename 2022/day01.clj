(ns day01
  (:require [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Example Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input
  "
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  ")

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(defn group-and-sum [input]
  (->> input
       (map #(if (= "" %) nil (Integer/parseInt %)))
       (partition-by nil?)
       (filter #(not= '(nil) %))
       (map #(apply + %))))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(defn part1 [input]
  (apply max (group-and-sum input)))

;; Example

(part1 (util/trim-split eg-input 2)) ; 24000

;; Answer

(part1 (util/trim-split (slurp "day01.input"))) ; 72017

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(defn part2 [input]
  (->> (group-and-sum input)
       (sort >)
       (take 3)
       (apply +)))

;; Example

(part2 (util/trim-split eg-input 2)) ; 45000

;; Answer

(part2 (util/trim-split (slurp "day01.input"))) ; 212520
