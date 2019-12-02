(ns aoc2019.day2
  (:require [clojure.string]))

(def the-input (-> (slurp "src/aoc2019/day2.txt")
                   (clojure.string/trim-newline)
                   (clojure.string/split #",")))

(def the-program (-> (mapv read-string the-input)
                     (assoc 1 12 2 2)))

(defn step [program pos]
  (let [opcode (get program pos)
        halt? (= 99 opcode)]
    (if halt?
      nil
      (let [reg1 (get program (+ 1 pos))
            reg2 (get program (+ 2 pos))
            reg3 (get program (+ 3 pos))
            opd1 (get program reg1)
            opd2 (get program reg2)]
        (case opcode
          1 (assoc program reg3 (+ opd1 opd2))
          2 (assoc program reg3 (* opd1 opd2)))))))

(defn exec [program]
  (loop [in program
         pos 0]
    (if-let [out (step in pos)]
      (recur out (+ 4 pos))
      in)))

(def answer1 (exec the-program))

(defn correct? [program noun verb answer]
  (let [in (assoc program 1 noun 2 verb)]
    (= answer (get (exec in) 0))))

(defn search [program answer]
  (for [noun (range 0 100)
        verb (range 0 100)
        :when (correct? program noun verb answer)]
    [noun verb]))

(def answer2 (search the-program 19690720))
