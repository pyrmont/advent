(ns aoc2019.day9
  (:require [clojure.string]))

(defn queue
  ([] (clojure.lang.PersistentQueue/EMPTY))
  ([coll] (reduce conj clojure.lang.PersistentQueue/EMPTY coll)))

(def the-input (-> (slurp "src/aoc2019/day9.txt")
                   (clojure.string/trim-newline)
                   (clojure.string/split #",")))

(def the-program (as-> the-input v
                       (mapv #(Integer/parseInt %) v)))

(defn stack-size [program]
  (count (:stack program)))

(defn get-value [program addr]
  (if (< addr (stack-size program))
    (get-in program [:stack addr])
    (get-in program [:heap addr] 0)))

(defn update-value [program addr value]
  (if (nil? addr)
    program
    (if (< addr (stack-size program))
      (assoc-in program [:stack addr] value)
      (assoc-in program [:heap addr] value))))

(defn update-pos [pos abs rel]
  {:abs (if (map? abs) (:jump abs) (+ (:abs pos) abs))
   :rel (if (map? rel) (:jump rel) (+ (:rel pos) rel))})

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
    (0, nil) (->> (+ (:abs pos) n) (get-value program) (get-value program))
    1        (get-value program (+ (:abs pos) n))
    2        (->> (+ (:abs pos) n) (get-value program) (+ (:rel pos)) (get-value program))))

(defn get-return [mode n program pos]
  (case (get mode (dec n))
    (0, nil) (->> (+ (:abs pos) n) (get-value program))
    1        (+ (:abs pos) n)
    2        (->> (+ (:abs pos) n) (get-value program) (+ (:rel pos)))))

(defn read-input [in]
  (peek in))

(defn remove-input [in]
  (pop in))

(defn write-output [out v]
  (conj out v))

(defn step [program pos in out]
  (let [opcode (get-value program (:abs pos))
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
          1 [(update-value program retn (+ opd1 opd2)) (update-pos pos 4 0) in out]
          2 [(update-value program retn (* opd1 opd2)) (update-pos pos 4 0) in out]
          3 [(update-value program (get-return mode 1 program pos) (read-input in)) (update-pos pos 2 0) (remove-input in) out]
          4 [(update-value program nil nil) (update-pos pos 2 0) in (write-output out opd1)]
          5 [(update-value program nil nil) (update-pos pos (if (zero? opd1) 3 {:jump opd2}) 0) in out]
          6 [(update-value program nil nil) (update-pos pos (if (zero? opd1) {:jump opd2} 3) 0) in out]
          7 [(update-value program retn (if (< opd1 opd2) 1 0)) (update-pos pos 4 0) in out]
          8 [(update-value program retn (if (= opd1 opd2) 1 0)) (update-pos pos 4 0) in out]
          9 [(update-value program nil nil) (update-pos pos 2 opd1) in out])))))

(defn exec [program pos in out]
  (if-let [[new-program new-pos new-in new-out] (step program pos in out)]
    (if (= out new-out)
      (recur new-program new-pos new-in new-out)
      [new-program new-pos new-in new-out])
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

(defn make-process [program]
  {:program {:stack program :heap {}} :pos {:abs 0 :rel 0}})

(def t1-program [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
(def t2-program [1102,34915192,34915192,7,4,7,99,0])
(def t3-program [104,1125899906842624,99])

(defn q1-tests [program]
  (-> (schedule (queue [(make-process program)]) (queue) (queue) true)
      (get 1)
      (seq)))

(def answer1 (-> (schedule (queue [(make-process the-program)]) (queue [1]) (queue) true)
                 (get 1)
                 (seq)))

(def answer2 (-> (schedule (queue [(make-process the-program)]) (queue [2]) (queue) true)
                 (get 1)
                 (seq)))
