(ns aoc2019.day11
  (:require [clojure.string]))

(defn queue
  ([] (clojure.lang.PersistentQueue/EMPTY))
  ([coll] (reduce conj clojure.lang.PersistentQueue/EMPTY coll)))

(def the-input (-> (slurp "src/aoc2019/day11.txt")
                   (clojure.string/trim-newline)
                   (clojure.string/split #",")))

(def the-program (as-> the-input v
                       (mapv #(BigInteger. %) v)))

(def hull (atom {}))
(def direction (atom :n))
(def location (atom [0 0]))

(defn clear! []
  (reset! hull {})
  (reset! direction :n)
  (reset! location [0 0]))

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

(defn paint-hull! [colour]
  (swap! hull assoc @location colour))

(defn get-dir [spin]
  (case spin
    0 (case @direction
        :n [:w [-1 0]]
        :e [:n [0 1]]
        :s [:e [1 0]]
        :w [:s [0 -1]])
    1 (case @direction
        :n [:e [1 0]]
        :e [:s [0 -1]]
        :s [:w [-1 0]]
        :w [:n [0 1]])))

(defn update-coords [curr adjust]
  [(+ (get curr 0) (get adjust 0))
   (+ (get curr 1) (get adjust 1))])

(defn move-robot! [spin]
  (let [[new-dir adjust] (get-dir spin)]
    (reset! direction new-dir)
    (swap! location update-coords adjust)))

(defn look-hull []
  (get @hull @location 0))

(defn update-robot [program pos in out]
  (let [new-colour (peek out)
        out (pop out)
        new-dir (peek out)
        new-out (pop out)]
    (paint-hull! new-colour)
    (move-robot! new-dir)
    [program pos (conj in (look-hull)) new-out]))

(defn exec [program pos in out]
  (if-let [[new-program new-pos new-in new-out] (step program pos in out)]
    (if (< (count new-out) 2)
      (recur new-program new-pos new-in new-out)
      (update-robot new-program new-pos new-in new-out))
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

(defn q1-test []
  (update-robot {} {} (queue) (queue [1 0])))

(defn run [program input]
  (-> [(make-process program)]
      (queue)
      (schedule (queue [input]) (queue) true)))

(def answer1 (let [_ (clear!)
                   _ (run the-program 0)]
               (-> @hull
                   (keys)
                   (count))))

(defn get-vertices [points]
  (reduce (fn [vertices point]
            [(max (get vertices 0) (get point 1))
             (max (get vertices 1) (get point 0))
             (min (get vertices 2) (get point 1))
             (min (get vertices 3) (get point 0))])
          [0 0 0 0]
          points))

(defn ->canvas [marks]
  (let [[t l d r] (get-vertices (keys marks))
        width (count (range r (inc l)))]
    (for [y (reverse (range d (inc t)))
          x (range r (inc l))
          :let [point (get marks [x y])
                colour (case point (0N nil) " " 1N "*")]]
      (if (= 0 (mod x width)) (str '\newline colour) colour))))

(def answer2 (let [_ (clear!)
                   _ (run the-program 1)]
               (-> @hull
                   (->canvas)
                   (clojure.string/join))))
