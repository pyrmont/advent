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
        (do
          # (++ total)
          (set pos (+ 100 pos)))
        (> pos 99)
        (do
          # (++ total)
          (set pos (- pos 100)))
        # default
        (break))))
  total)

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))

(def input-raw (slurp "day01.input"))

(def part1-input (interpret input-raw))
(def part1-answer1 (answer1 part1-input))
