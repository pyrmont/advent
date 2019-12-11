(ns aoc2019.day10
  (:require [clojure.string]
            [clojure.math.numeric-tower :as math]))

(def the-input (-> (slurp "src/aoc2019/day10.txt")
                   (clojure.string/trim-newline)))

(defn get-asteroids
  ([grid]
   (get-asteroids grid, 0, 0, 0, #{}))
  ([grid, pos, x, y, asteroids]
   (case (get grid pos)
     \# (recur grid, (inc pos), (inc x), y, (conj asteroids {:x x :y y}))
     \. (recur grid, (inc pos), (inc x), y, asteroids)
     \newline (recur grid, (inc pos), 0, (inc y), asteroids)
     nil asteroids)))

(defn m-dist [a b]
  (+ (math/abs (- (:x a) (:x b))) (math/abs (- (:y a) (:y b)))))

(defn closer-to? [target a b]
  (< (m-dist a target) (m-dist b target)))

(defn same-x-side? [target a b]
  (or
    (and (< (:x target) (:x a)) (< (:x target) (:x b)))
    (and (> (:x target) (:x a)) (> (:x target) (:x b)))
    (and (= (:x target) (:x a)) (= (:x target) (:x b)))))

(defn same-y-side? [target a b]
  (or
    (and (< (:y target) (:y a)) (< (:y target) (:y b)))
    (and (> (:y target) (:y a)) (> (:y target) (:y b)))
    (and (= (:y target) (:y a)) (= (:y target) (:y b)))))

(defn same-side? [target a b]
  (and (same-x-side? target a b) (same-y-side? target a b)))

(defn same-ratio? [target a b]
  (cond
    (= (:x target) (:x a) (:x b)) true
    (= (:y target) (:y a) (:y b)) true
    (= (:x target) (:x a)) false ;; We're only here if the above fails
    (= (:x target) (:x b)) false ;; Same as above
    (= (:y target) (:y a)) false ;; Same as above
    (= (:y target) (:y b)) false ;; Same as above
    (= (math/abs (/ (- (:x target) (:x a)) (- (:y target) (:y a))))
       (math/abs (/ (- (:x target) (:x b)) (- (:y target) (:y b))))) true
    :else false))

(defn blocked-or-blocker [candidate visibles comparison]
  (loop [remaining visibles
         a (first remaining)]
    (cond
      (nil? a) [nil nil]
      (and (same-side? candidate comparison a)
           (same-ratio? candidate comparison a)) (if (closer-to? candidate comparison a) [a nil] [nil a])
      :else (recur (rest remaining) (first (rest remaining))))))

(defn get-visibles [asteroids candidate]
  (reduce (fn [visibles comparison]
            (let [[blocked blocker] (blocked-or-blocker candidate visibles comparison)]
              (cond
                blocked (-> (disj visibles blocked) (conj comparison))
                blocker visibles
                :else (conj visibles comparison))))
          #{}
          (disj asteroids candidate)))

(def t1-grid ".#..#\n.....\n#####\n....#\n...##")
(def t1-asteroids (-> t1-grid get-asteroids))
(def t1-count (->> (map #(get-visibles t1-asteroids %) t1-asteroids)
                   (map count)))

(def t2-grid "......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####")
(def t2-asteroids (-> t2-grid get-asteroids))
(def t2-count (->> (map #(get-visibles t2-asteroids %) t2-asteroids)
                 (map count)))

(defn find-base [asteroids]
  (reduce (fn [best a]
            (let [curr {:coords a :visibles (get-visibles asteroids a)}]
              (if (< (count (:visibles best)) (count (:visibles curr))) curr best)))
          {:coords nil :visibles #{}}
          asteroids))

(def the-asteroids (-> the-input get-asteroids))
(def the-base (reduce (fn [best a]
                        (let [curr {:coords a :visibles (get-visibles the-asteroids a)}]
                          (if (< (count (:visibles best)) (count (:visibles curr))) curr best)))
                      {:coords nil :visibles #{}}
                      the-asteroids))
(def answer1 (count (:visibles the-base)))

(defn get-angle [origin a]
  (Math/atan2 (- (:x a) (:x origin)) (- (:y a) (:y origin))))

(defn earlier? [origin a b]
  (let [two-pi (* Math/PI 2)
        a-angle (get-angle origin a)
        b-angle (get-angle origin b)]
    (cond
      (= 0 a-angle) -1
      (= 0 b-angle) 1
      :else (> a-angle b-angle))))

(defn sort-earliest [origin visibles]
  (sort #(earlier? origin %1 %2) visibles))

(def t3-grid ".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##\n")
(def t3-asteroids (-> t3-grid get-asteroids))

(def answer2 (as-> the-base v
                   (sort-earliest (:coords v) (:visibles v))
                   (nth v 199)
                   (+ (* 100 (:x v)) (:y v))))
