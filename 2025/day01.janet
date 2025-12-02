(def ex-raw
  ```
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (some (* :turn (? "\n")))
               :turn (group (* '(+ "L" "R") (number :d+)))}
             input))

(defn answer1
  [turns]
  (var total 0)
  (var pos 50)
  (each [dir clicks] turns
    (case dir
      "L"
      (set pos (- pos clicks))
      "R"
      (set pos (+ pos clicks)))
    (forever
      (cond
        (zero? pos)
        (do
          (++ total)
          (break))
        (< pos 0)
        (set pos (+ 100 pos))
        (> pos 99)
        (set pos (- pos 100))
        # default
        (break))))
  total)

(defn answer2
  [turns]
  (var total 0)
  (var pos 50)
  (each [dir clicks] turns
    (+= total (math/floor (/ clicks 100)))
    (case dir
      "L"
      (do
        (set pos (if (zero? pos) 100 pos))
        (set pos (- pos (% clicks 100))))
      "R"
      (set pos (+ pos (% clicks 100))))
    (cond
      (zero? pos)
      (++ total)
      (< pos 0)
      (do
        (++ total)
        (set pos (+ 100 pos)))
      (> pos 99)
      (do
        (++ total)
        (set pos (- pos 100)))))
  total)

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
(def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day01.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
(def real-answer2 (answer2 real-input))
