(def expense-report (slurp "day01.txt"))
(def expenses (->> (string/trim expense-report)
                   (string/split "\n")
                   (map scan-number)))

# Part 1

(->> (seq [x :in expenses
           y :in expenses :when (= 2020 (+ x y))]
       [x y])
     first
     (apply *)
     print)

# Part 2

(->> (seq [x :in expenses
           y :in expenses
           z :in expenses :when (= 2020 (+ x y z))]
       [x y z])
     first
     (apply *)
     print)
