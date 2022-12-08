(ns day07
  (:require [clojure.string :as str]
            [clojure.walk :as walk]
            [utilities :as util]))

;;;;;;;;;;;;;;;;;;;;
;; Input
;;;;;;;;;;;;;;;;;;;;

(def eg-input (util/trim-split
  "
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  " 2))

(def input (util/trim-split (slurp "day07.input")))

;;;;;;;;;;;;;;;;;;;;
;; Common Functions
;;;;;;;;;;;;;;;;;;;;

(defn cd [dir pwd]
  (if (= dir "..")
    (pop pwd)
    (conj pwd dir)))

(defn add-to [tree pwd [size-or-dir item-name]]
  (let [path (conj pwd item-name)]
    (if (= size-or-dir "dir")
      (if (nil? (get-in tree path))
        (assoc-in tree path {})
        tree)
      (assoc-in tree path (parse-long size-or-dir)))))

(defn make-tree [lines line-num tree pwd]
  (if (= (count lines) line-num)
    tree
    (let [line (get lines line-num)
          [new-tree new-pwd] (cond
                               (= line "$ ls") [tree pwd]
                               (= line "$ cd /") [tree ["/"]]
                               (= line "$ cd ..") [tree (cd ".." pwd)]
                               (str/starts-with? line "$ cd") [tree (cd (subs line 5) pwd)]
                               :else [(add-to tree pwd (str/split line #" ")) pwd])]
      (recur lines (inc line-num) new-tree new-pwd))))

(defn dir-size [dir]
  (reduce #(+ %1
              (if (number? %2) %2 (:size %2)))
          0
          (vals dir)))

(defn calc-sizes [tree]
  (walk/postwalk (fn [node]
                   (if-not (and (map-entry? node) (map? (val node)))
                     node
                     (let [k (key node)
                           v (val node)]
                       [k (merge (into {} (filter #(map? (second %)) v))
                                 {:size (dir-size v)})])))
                 tree))

;;;;;;;;;;;;;;;;;;;;
;; Part 1
;;;;;;;;;;;;;;;;;;;;

(defn sum-sizes [limit tree]
  (->> (tree-seq associative? vals (get tree "/"))
       (filter #(and (number? %) (< % limit)))
       (reduce +)))

(defn part1 [input]
  (->> (make-tree input 0 {} "/")
       (calc-sizes)
       (sum-sizes 100000)))

;; Example

(part1 eg-input) ; 95437

;; Answer

(part1 input) ; 1447046

;;;;;;;;;;;;;;;;;;;;
;; Part 2
;;;;;;;;;;;;;;;;;;;;

(defn find-dir [total req tree]
  (->> (tree-seq associative? vals (get tree "/"))
       (filter #(and (map? %) (> (:size %) (- req (- total (:size (get tree "/")))))))
       (reduce #(min %1 (:size %2)) req)))

(defn part2 [input]
  (->> (make-tree input 0 {} "/")
       (calc-sizes)
       (find-dir 70000000 30000000)))

;; Example

(part2 eg-input) ; 24933642

;; Answer

(part2 input) ; 578710
