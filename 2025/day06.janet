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
               :op (/ '(set "+*") ,symbol)}
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

(defn answer2
  [raw]
  (def res @[])
  (def lines (string/split "\n" raw))
  (def ll (array/pop lines))
  (def ops (peg/match ~(some (* (any " ") (/ '(set "+*") ,symbol))) ll))
  (def widths @[])
  (var i 0)
  (var w 0)
  (while (def c (get ll i))
    (unless (or (zero? w) (= (chr " ") c))
      (array/push widths (dec w))
      (set w 0))
    (++ w)
    (++ i))
  (array/push widths w)
  (set i 0)
  (each [sym w] (partition 2 (interleave ops widths))
    (def op (module/value root-env sym))
    (def operands @[])
    (def beg i)
    (while (< (- i beg) w)
      (def b @"")
      (each l lines
        (def c (get l i))
        (unless (or (nil? c) (= (chr " ") c))
          (buffer/push b c)))
      (array/push operands (scan-number b))
      (++ i))
    (++ i)
    (array/push res (apply op operands)))
  (apply + res))

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
(def ex-answer2 (answer2 ex-raw))

(def real-raw (slurp "day06.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
(def real-answer2 (answer2 (string/slice real-raw 0 -2)))
