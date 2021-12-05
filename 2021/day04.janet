# Inputs

(def ex-input
  ```
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7
  ```)

(def input (-> (slurp "day04.input") string/trim))

# Parser

(def g (peg/compile
  ~{:main  (* :draw (some (* :sep :board)))
    :draw  (group (* :num (any (* "," :num))))
    :sep   :s+
    :board (group (* :row (4 (* :s+ :row))))
    :row   (group (* :num (4 (* :s+ :num))))
    :num   (/ ':d+ ,scan-number)}))

# Game Functions

(defn game-state [input]
  (def draw-and-boards (peg/match g input))
  (def draw (first draw-and-boards))
  (def arrs (array/slice draw-and-boards 1))
  (def boards @[])
  (each arr arrs
    (def nums @{})
    (loop [row :range-to [0 4]
           col :range-to [0 4]]
      (def num (get-in arr [row col]))
      (put nums num [row col]))
    (array/push boards {:arr arr :nums nums :marks @{}}))
  [draw boards])

(defn bingo? [board row col]
  (var cnt 0)
  (loop [i :range-to [0 4]]
    (def num (get-in board [:arr row i]))
    (if (get-in board [:marks num])
      (++ cnt)))
  (unless (= 5 cnt)
    (set cnt 0)
    (loop [i :range-to [0 4]]
      (def num (get-in board [:arr i col]))
      (if (get-in board [:marks num])
        (++ cnt))))
  (= 5 cnt))

(defn play-bingo [gs &opt keep-playing?]
  (var bingo nil)
  (var winner nil)
  (def draw (gs 0))
  (var round (gs 1))
  (each num draw
    (var next-round @[])
    (each board round
      (array/push next-round board)
      (when-let [[row col] (get-in board [:nums num])]
        (put-in board [:marks num] true)
        (when (bingo? board row col)
          (array/pop next-round)
          (set bingo num)
          (set winner board)
          (unless keep-playing?
            (break)))))
    (if (zero? (length next-round))
      (break)
      (set round next-round)))
  [bingo winner])

(defn unmarked [nums marks]
  (def res @[])
  (each num nums
    (unless (marks num)
      (array/push res num)))
  res)

(defn answer [input &opt keep-playing?]
  (def [bingo winner] (play-bingo (game-state input) keep-playing?))
  (def score (* bingo (reduce + 0 (unmarked (keys (winner :nums)) (winner :marks)))))
  [bingo score])

# Answers

(def ex1-answer (answer ex-input))
(print "Bingo called at " (ex1-answer 0) " with final score " (ex1-answer 1))

(def p1-answer (answer input))
(print "Bingo called at " (p1-answer 0) " with final score " (p1-answer 1))

(def ex2-answer (answer ex-input true))
(print "Bingo called at " (ex2-answer 0) " with final score " (ex2-answer 1))

(def p2-answer (answer input true))
(print "Bingo called at " (p2-answer 0) " with final score " (p2-answer 1))
