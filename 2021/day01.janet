(def input (-> (slurp "day01.input") string/trim))

(def sweeps (->> (string/split "\n" input)
                 (map scan-number)))

## Part 1

(var increases 0)
(var previous math/inf)

(each sweep sweeps
  (if (> sweep previous)
    (++ increases))
  (set previous sweep))

(print "The answer to part 1 is " increases)

## Part 2

(set increases 0)
(set previous math/inf)

(loop [i :range-to [0 (- (length sweeps) 3)]]
  (def total (+ (get sweeps i)
                (get sweeps (+ i 1))
                (get sweeps (+ i 2))))
  (if (> total previous)
    (++ increases))
  (set previous total))

(print "The answer to part 2 is " increases)
