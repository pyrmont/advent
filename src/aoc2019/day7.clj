(ns aoc2019.day7
  (:require [clojure.string]))

(defn queue
  ([] (clojure.lang.PersistentQueue/EMPTY))
  ([coll] (reduce conj clojure.lang.PersistentQueue/EMPTY coll)))

(def the-input (-> (slurp "src/aoc2019/day7.txt")
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

(defn read-input [in]
  (peek in))

(defn remove-input [in]
  (pop in))

(defn write-output [out v]
  (conj out v))

(defn update-program [program pos value]
  (if (nil? pos)
    program
    (assoc program pos value)))

(defn step [program pos in out]
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
          1 [(update-program program retn (+ opd1 opd2)) (+ 4 pos) in out]
          2 [(update-program program retn (* opd1 opd2)) (+ 4 pos) in out]
          3 [(update-program program (get-return mode 1 program pos) (read-input in)) (+ 2 pos) (remove-input in) out]
          4 [(update-program program nil nil) (+ 2 pos) in (write-output out opd1)]
          5 [(update-program program nil nil) (if (zero? opd1) (+ 3 pos) opd2) in out]
          6 [(update-program program nil nil) (if (zero? opd1) opd2 (+ 3 pos)) in out]
          7 [(update-program program retn (if (< opd1 opd2) 1 0)) (+ 4 pos) in out]
          8 [(update-program program retn (if (= opd1 opd2) 1 0)) (+ 4 pos) in out])))))

(defn exec [program pos in out]
  (if-let [[new-program new-pos new-in new-out] (step program pos in out)]
    (if (= out new-out)
      (recur new-program new-pos new-in new-out)
      (let [new-in (conj new-in (peek new-out))
            new-out (pop new-out)]
        [new-program new-pos new-in new-out]))
    nil))

(defn schedule [processes in out circular]
  (if-let [{:keys [program pos]} (peek processes)]
    (if-let [[program pos in out] (exec program pos in out)]
      (recur (if circular
               (conj (pop processes) {:program program :pos pos})
               (pop processes))
             in out circular)
      (recur (pop processes) in out circular))
    [in out]))

(defn make-processes [program phases]
  (-> (map #(let [in (queue [%])
                  out (queue)
                  [program pos _ _] (step program 0 in out)]
              {:program program :pos pos}) phases)
      (queue)))

(defn permutations [colls]
  (if (= 1 (count colls))
    (list colls)
    (for [head colls
          tail (permutations (disj (set colls) head))]
      (cons head tail))))

(def answer1 (->> (permutations #{0 1 2 3 4})
                  (map #(-> (make-processes the-program %)
                            (schedule (queue [0]) (queue) false)
                            (first)
                            (first)))
                  (apply max)))

(def answer2 (->> (permutations #{5 6 7 8 9})
                  (map #(-> (make-processes the-program %)
                            (schedule (queue [0]) (queue) true)
                            (first)
                            (first)))
                  (apply max)))

; (def answer1 (->> (permutations #{0 1 2 3 4}) (map #(chain the-program %)) (apply max)))

(def t1-program [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0])
(def t1-phases [4,3,2,1,0])
(def t2-program [3,23,3,24,1002,24,10,24,1002,23,-1,23,
                 101,5,23,23,1,24,23,23,4,23,99,0,0])
(def t2-phases [0,1,2,3,4])
(def t3-program [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
                 1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0])
(def t3-phases [1,0,4,3,2])

(defn q1-tests [program phases]
  (-> (make-processes program phases)
      (schedule (queue [0]) (queue) false)
      (first)
      (first)))

; (defn collect-signal [program start phases]
;   (let [in (async/chan)
;         out (async/chan)]
;     (make-and-connect program in out phases)
;     (write-output in start)
;     (async/poll! out)))

; (defn collect-signals [program permutations]
;   (map (fn [x]
;          (let [in (async/chan)
;                out (async/chan)]
;            (make-and-connect program in out x)
;            (write-output in 0)
;            (async/<!! out)))
;        permutations))

; (def answer1 (->> (permutations #{0 1 2 3 4}) (map #(make-and-connect the-program input-1 output-1 %)) (apply max)))
