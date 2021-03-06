(import spork/misc :as spork)

(defn sum-of-any-previous-pair? [target candidates]
  (def num-candidates (length candidates))
  (var sum-found? false)
  (loop [i :range [0 num-candidates]
           :until sum-found?]
    (loop [j :range [i num-candidates]
             :until sum-found?]
      (when (= target (+ (candidates i) (candidates j)))
        (set sum-found? true))))
  sum-found?)

(defn find-first-invalid [numbers window-size]
  (var val nil)
  (loop [i :range [window-size (length numbers)]
           :until val]
    (when (not (sum-of-any-previous-pair?
                 (numbers i)
                 (array/slice numbers (- i window-size) i)))
      (set val (numbers i))))
  val)

(defn find-contiguous-sets [target numbers]
  (def num-numbers (length numbers))
  (var res @[])
  (var back 0)
  (var front 0)
  (while (< back num-numbers)
    (if (< (- front back) 2)
      (if (= front num-numbers) (++ back) (++ front))
      (let [spread (array/slice numbers back front)
            total  (apply + spread)]
        (cond
          (= total target) (do (array/push res spread)
                               (++ back))
          (< total target) (if (= front num-numbers) (++ back) (++ front))
          (> total target) (++ back)))))
  res)

# Example

(def example
  (->>
    ```
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    ```
    spork/dedent
    (string/split "\n")
    (map scan-number)))

(def example1-answer
  (find-first-invalid example 5))

(print "The first invalid number is " example1-answer)

(def example2-answer
  (->> (find-contiguous-sets example1-answer example)
       (map |(+ (apply min $) (apply max $)))
       (apply max)))

(print "The encryption weakness is " example2-answer)

# Part 1

(def part1-input
  (->> (slurp "day09.txt")
       string/trim
       (string/split "\n")
       (map scan-number)))

(def part1-answer
  (find-first-invalid part1-input 25))

(print "The first invalid number is " part1-answer)

# Part 2

(def part2-answer
  (->> (find-contiguous-sets part1-answer part1-input)
       (map |(+ (apply min $) (apply max $)))
       (apply max)))

(print "The encryption weakness is " part2-answer)
