(ns aoc2019.day5
  (:require [clojure.string]))

(def the-input (-> (slurp "src/aoc2019/day5.txt")
                   (clojure.string/trim-newline)
                   (clojure.string/split #",")))

(def the-program (as-> the-input v
                       (mapv #(Integer/parseInt %) v)))

(defn get-op [inst size]
  (if (<= size 2)
    (Integer/parseInt inst)
    (Integer/parseInt (subs inst (- size 2) size))))

(defn get-modes [inst size]
  (if (<= size 2)
    nil
    (as-> (subs inst 0 (- size 2)) v
          (clojure.string/split v #"")
          (map #(Integer/parseInt %) v)
          (reverse v)
          (vec v))))

(defn get-parms [mode n program pos]
  (case (get mode (dec n))
    (0, nil) (->> (+ pos n) (get program) (get program))
    1        (get program (+ pos n))))

(defn get-return [mode n program pos]
  (case (get mode (dec n))
    (0, nil) (->> (+ pos n) (get program))
    1        (+ pos n)))

(defn update-program [program pos value]
  (if (nil? pos)
    program
    (assoc program pos value)))

(defn step [program pos in]
  (let [opcode (get program pos)
        halt? (= 99 opcode)]
    (if halt?
      nil
      (let [inst (str opcode)
            size (count inst)
            op   (get-op inst size)
            mode (get-modes inst size)
            opd1 (get-parms mode 1 program pos)
            opd2 (get-parms mode 2 program pos)
            retn (get-return mode 3 program pos)]
        (case op
          1 [(update-program program retn (+ opd1 opd2)) (+ 4 pos) nil nil]
          2 [(update-program program retn (* opd1 opd2)) (+ 4 pos) nil nil]
          3 [(update-program program (get-return mode 1 program pos) in) (+ 2 pos) nil nil]
          4 [(update-program program nil nil) (+ 2 pos) nil opd1]
          5 [(update-program program nil nil) (if (zero? opd1) (+ 3 pos) opd2) nil nil]
          6 [(update-program program nil nil) (if (zero? opd1) opd2 (+ 3 pos)) nil nil]
          7 [(update-program program retn (if (< opd1 opd2) 1 0)) (+ 4 pos) nil nil]
          8 [(update-program program retn (if (= opd1 opd2) 1 0)) (+ 4 pos) nil nil])))))

(defn exec
  ([program in]
   (exec program 0 in nil))
  ([program pos in out]
   (if-let [[new-program new-pos in out] (step program pos in)]
     ; (let [keep-out (if (nil? new-out) out new-out)]
     (recur new-program new-pos in out)
     [program out])))

(def answer1 (get (exec the-program 1) 1))

(defn correct? [program noun verb answer]
  (let [in (assoc program 1 noun 2 verb)]
    (= answer (get (exec in) 0))))

(def answer2 (get (exec the-program 5) 1))
