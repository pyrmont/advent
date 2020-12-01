(def expense-report (slurp "day01.txt"))
(def expenses (->> (string/trim expense-report)
                   (string/split "\n")
                   (map scan-number)))

# Part 1

(each entry-1 expenses
  (each entry-2 expenses
    (when (= 2020 (+ entry-1 entry-2))
      (print (* entry-1 entry-2)))))

# Part 2

(each entry-1 expenses
  (each entry-2 expenses
    (each entry-3 expenses
      (when (= 2020 (+ entry-1 entry-2 entry-3))
        (print (* entry-1 entry-2 entry-3))))))

