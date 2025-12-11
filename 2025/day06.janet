(def ex-raw
  ```
  123 328  51 64
   45 64  387 23
    6 98  215 314
  *   +   *   +
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (* (some :operands) :ops)
               :operands (+ (* (any " ") "\n")
                            (group (some (* (any " ") (number :d+)))))
               :ops (group (some (* (any " ") :op)))
               :op (/ '(set "+-*/") ,symbol)}
             input))

(defn answer1
  [vals]
  (def res @[])
  (var i 0)
  (while (< i (length (first vals)))
    (def op (module/value root-env (get (last vals) i)))
    (def operands @[])
    (var j 0)
    (while (< j (dec (length vals)))
      (array/push operands (get-in vals [j i]))
      (++ j))
    (array/push res (apply op operands))
    (++ i))
  (apply + res))

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
# (def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day06.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
# (def real-answer2 (answer2 real-input))
