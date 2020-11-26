(ns aoc2019.day4
  (:require [clojure.string]))

(def the-input (-> (slurp "src/aoc2019/day4.txt")
                   (clojure.string/trim-newline)))

(def the-limits (as-> the-input v
                      (clojure.string/split v #"-")
                      (map read-string v)))

(defn digits-increase? [coll]
  (apply <= coll))

(defn identical-pairs? [coll]
  (let [a (first coll)
        b (second coll)]
    (cond
      (empty? coll) false
      (= a b) true
      :else (recur (rest coll)))))

(defn fulfil-criteria-1? [n]
  (let [digits (->> n str (map (comp read-string str)))]
    (and
      (digits-increase? digits)
      (identical-pairs? digits))))

(defn search [criteria start end]
  (count (filter criteria (range start end))))

(def answer1 (apply (partial search fulfil-criteria-1?) the-limits))

(defn identical-pairs-only? [coll i]
  (let [a (nth coll (- i 1) nil)
        b (nth coll i nil)
        c (nth coll (+ 1 i) nil)
        d (nth coll (+ 2 i) nil)]
    (cond
      (= i (count coll)) false
      (and (not (= a b)) (= b c) (not (= c d))) true
      :else (recur coll (+ 1 i)))))

(defn fulfil-criteria-2? [n]
  (let [digits (->> n str (map (comp read-string str)))]
    (and
      (digits-increase? digits)
      (identical-pairs-only? digits 0))))

(def answer2 (apply (partial search fulfil-criteria-2?) the-limits))
