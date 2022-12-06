(ns day06
  (:require [clojure.string :as str]
            [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input (util/trim-split
  "
  mjqjpqmgbljsphdztnvjfqwrcgsmlb
  bvwbjplbgvbhsrlpgdmjqwftvncz
  nppdvjthqldpwncqszvftbrmjlhg
  nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
  zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
  " 2))

(def input (util/trim-split (slurp "day06.input")))

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(defn find-start [input length marker pos]
  (if (= length (count marker))
    pos
    (let [c (get input pos)]
      (if-let [start (str/index-of marker c)]
        (let [new-pos (- pos (- (count marker) 1 start))
              new-c (get input new-pos)]
          (recur input length (str new-c) (inc new-pos)))
        (recur input length (str marker c) (inc pos))))))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(defn part1 [input]
  (find-start input 4 "" 0))

;; Example

(map part1 eg-input) ; (7 5 6 10 11)

;; Answer

(part1 (first input)) ; 1080

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(defn part2 [input]
  (find-start input 14 "" 0))

;; Example

(map part2 eg-input) ; (19 23 23 29 26)

;; Answer

(part2 (first input)) ; 3645
