(ns day02
  (:require [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Example Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input
  "
  A Y
  B X
  C Z
  ")

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(def points
  {:rock 1, :paper 2, :scissors 3
   :lose 0, :draw 3 :win 6})

(def results
  {[:rock :rock] :draw
   [:rock :paper] :win
   [:rock :scissors] :lose
   [:paper :rock] :lose
   [:paper :paper] :draw
   [:paper :scissors] :win
   [:scissors :rock] :win
   [:scissors :paper] :lose
   [:scissors :scissors] :draw})

(defn calculate [move-1 move-2]
  (let [result (results [move-1 move-2])]
    (+ (points result) (points move-2))))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(def meanings-1
  {\A :rock, \B :paper, \C :scissors
   \X :rock, \Y :paper, \Z :scissors})

(defn part1 [input]
  (reduce #(let [move-1 (meanings-1 (first %2))
                 move-2 (meanings-1 (last %2))
                 score  (calculate move-1 move-2)]
             (+ %1 score)) 0 input))

;; Example

(part1 (util/trim-split eg-input 2)) ; 15

;; Answer

(part1 (util/trim-split (slurp "day02.input"))) ; 11063

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(def meanings-2
  {[\A \X] :scissors
   [\A \Y] :rock
   [\A \Z] :paper
   [\B \X] :rock
   [\B \Y] :paper
   [\B \Z] :scissors
   [\C \X] :paper
   [\C \Y] :scissors
   [\C \Z] :rock})

(defn part2 [input]
  (reduce #(let [move-1 (meanings-1 (first %2))
                 move-2 (meanings-2 [(first %2) (last %2)])
                 score  (calculate move-1 move-2)]
             (+ %1 score)) 0 input))

;; Example

(part2 (util/trim-split eg-input 2))

;; Answer

(part2 (util/trim-split (slurp "day02.input")))
