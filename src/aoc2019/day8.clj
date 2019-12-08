(ns aoc2019.day8
  (:require [clojure.string]))

(def the-input (-> (slurp "src/aoc2019/day8.txt")
                   (clojure.string/trim-newline)))

(def the-layers (->> (clojure.string/split the-input #"")
                     (map #(Integer/parseInt %))
                     (partition 150)))

(defn get-least-zeros [layers]
  (->> (map frequencies layers) (reduce #(if (< (get %2 0) (get %1 0)) %2 %1))))

(def answer1 (-> (get-least-zeros the-layers) (select-keys [1 2]) (vals) ((partial apply *))))

(defn choose-pixels [a b]
  (let [previous (vec a)
        current  (vec b)]
    (for [i (range 0 (count current))
          :let [prev_pixel (get previous i)
                curr_pixel (get current i)]]
      (if (= 2 prev_pixel) curr_pixel prev_pixel))))

(defn composite [layers]
  (reduce choose-pixels layers))

(defn paint [composited width]
  (->> (map #(case % 0 " " 1 "*" 2 " ") composited)
       (partition width)
       (interpose \newline)
       (flatten)
       (clojure.string/join)))

(def answer2 (-> the-layers (composite) (paint 25)))
