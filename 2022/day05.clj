(ns day05
  (:require [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input (util/trim-split
  "
      [D]    
  [N] [C]    
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  " 2))

(def input (util/trim-split (slurp "day05.input")))

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(defn diagram->crates [diagram]
  (->> (drop-last diagram)
       (map #(->> (partition 3 4 %)
                  (map second)))
       reverse
       (apply (partial map conj (repeatedly list)))
       (mapv (partial remove #(= \space %)))))

(defn move-crates [crates moves move-fn]
  (if (empty? moves)
    crates
    (let [move (->> (first moves)
                    (re-find #"move (\d+) from (\d) to (\d)")
                    rest
                    (map parse-long))
          crates (move-fn crates move)]
      (recur crates (rest moves) move-fn))))

(defn simulate [lines move-fn]
  (let [[diagram _ moves] (partition-by empty? lines)
        crates (diagram->crates diagram)]
    (reduce #(str %1 (first %2)) "" (move-crates crates moves move-fn))))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(defn move-1 [crates [n from to]]
  (let [from-index (dec from)
        to-index (dec to)
        from-stack (get crates from-index)
        to-stack (get crates to-index)]
    (-> (assoc crates to-index (into to-stack (take n from-stack)))
        (assoc from-index (drop n from-stack)))))

(defn part1 [lines]
  (simulate lines move-1))

;; Example

(part1 eg-input) ; "CMZ"

;; Answer

(part1 input) ; "WHTLRMZRC"

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(defn move-2 [crates [n from to]]
  (let [from-index (dec from)
        to-index (dec to)
        from-stack (get crates from-index)
        to-stack (get crates to-index)]
    (-> (assoc crates to-index (into to-stack (reverse (take n from-stack))))
        (assoc from-index (drop n from-stack)))))

(defn part2 [lines]
  (simulate lines move-2))

;; Example

(part2 eg-input) ; "MCD"

;; Answer

(part2 input) ; "GMPMLWNMG"
