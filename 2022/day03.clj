(ns day03
  (:require [clojure.set :as set]
            [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Example Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input
  "
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  ")

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(defn char->val [c]
  (let [ascii (int c)]
    (if (> ascii 96)
      (- ascii 96)
      (- ascii 38))))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(defn find-common-in-bag [line]
  (let [n (count line)
        bag (partition (/ n 2) line)
        items (map clojure.core/set bag)]
    (apply set/intersection items)))

(defn part1 [input]
  (->> (map find-common-in-bag input)
       (reduce #(+ %1 (char->val (first %2))) 0)))

;; Example

(part1 (util/trim-split eg-input 2)) ; 157

;; Answer

(part1 (util/trim-split (slurp "day03.input"))) ; 7980

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(defn find-common-in-group [group]
  (let [items (map clojure.core/set group)]
    (apply set/intersection items)))

(defn part2 [input]
  (->> (partition 3 input)
       (map find-common-in-group)
       (reduce #(+ %1 (char->val (first %2))) 0)))

;; Example

(part2 (util/trim-split eg-input 2)) ; 70

;; Answer

(part2 (util/trim-split (slurp "day03.input"))) ; 2881
