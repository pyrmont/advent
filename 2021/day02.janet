(def g
  ~{:main (some :cmd)
    :cmd  (* :dir " " :amt (? "\n"))
    :dir  '(+ "up" "down" "forward")
    :amt  (/ ':d+ ,scan-number)})

(def input (slurp "day02.input"))

(def commands (->> (peg/match g input) (partition 2)))

(var x 0)
(var z 0)

# Example 1

(def example
  `forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  `)

(def ex-commands (->> (peg/match g example) (partition 2)))

(each [dir amt] ex-commands
  (case dir
    "forward" (set x (+ x amt))
    "up"      (set z (- z amt))
    "down"    (set z (+ z amt))))

(print "The horizontal position in example 1 is " x)
(print "The depth in example 1 is " z)
(print "Multiplying these together produces " (* x z))

# Part 1

(set x 0)
(set z 0)

(each [dir amt] commands
  (case dir
    "forward" (set x (+ x amt))
    "up"      (set z (- z amt))
    "down"    (set z (+ z amt))))

(print "The horizontal position in part 1 is " x)
(print "The depth in part 1 is " z)
(print "Multiplying these together produces " (* x z))


# Example 2

(set x 0)
(set z 0)
(var aim 0)

(each [dir amt] ex-commands
  (case dir
    "forward" (do (set x (+ x amt)) (set z (+ z (* aim amt))))
    "up"      (set aim (- aim amt))
    "down"    (set aim (+ aim amt))))

(print "The horizontal position in example 2 is " x)
(print "The depth in example 2 is " z)
(print "Multiplying these together produces " (* x z))

# Part 2

(set x 0)
(set z 0)
(set aim 0)

(each [dir amt] commands
  (case dir
    "forward" (do (set x (+ x amt)) (set z (+ z (* aim amt))))
    "up"      (set aim (- aim amt))
    "down"    (set aim (+ aim amt))))

(print "The horizontal position in part 2 is " x)
(print "The depth in part 2 is " z)
(print "Multiplying these together produces " (* x z))
