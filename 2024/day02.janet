# Input

(def ex-raw
  ```
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  ```)

(def real-raw (slurp "day02.input"))

# Functions

(defn interpret [s]
  (->> (peg/match ~(some (group (* (some (* (/ ':d+ ,scan-number) (some " ")))
                                   (* (/ ':d+ ,scan-number) (+ "\n" -1)))))
                  s)))

(defn answer-1 [data]
  (var safes 0)
  (each report data
    (when (or (< ;report) (> ;report))
      (var i 1)
      (while (def cur (get report i))
        (def prv (report (dec i)))
        (if (and (not= cur prv)
                 (< 3 (math/abs (- cur prv))))
          (break))
        (++ i))
      (when (= i (length report))
        (++ safes))))
  safes)

(defn check [can-skip? i cmpr report]
  (def prv (get report (- i 1)))
  (def cur (get report i))
  (def nxt1 (get report (+ i 1)))
  (def nxt2 (get report (+ i 2)))
  (def nxt3 (get report (+ i 3)))
  (defn safe? [p0 p1 p2]
    (and (cond
           (nil? p0)
           (cmpr p1 p2)
           (nil? p2)
           (cmpr p0 p1)
           # else
           (cmpr p0 p1 p2))
         (not= p0 p1 p2)
         (or (nil? p0) (< (math/abs (- p0 p1)) 4))
         (or (nil? p2) (< (math/abs (- p1 p2)) 4))))
  (when (safe? prv cur nxt1)
    (break :ok))
  (unless can-skip?
    (break :fail))
  (when (nil? nxt2) (safe? prv cur nxt2)
    (break :skip-last))
  (when (and (safe? prv cur nxt2) (safe? cur nxt2 nxt3))
    (break :skip-next))
  (when (safe? prv nxt1 nxt2)
    (break :skip-curr))
  :fail)

(defn safe-report? [cmpr report]
  (var safe? true)
  (var can-skip? true)
  (var i 0)
  (while (< i (length report))
    (case (check can-skip? i cmpr report)
      :fail
      (do
        (set safe? false)
        (break))
      :skip-curr
      (do
        (set can-skip? false)
        (++ i))
      :skip-next
      (do
        (set can-skip? false)
        (set i (+ 2 i))))
    (++ i))
  safe?)

(defn answer-2 [data]
  (var safes 0)
  (each report data
    (if (safe-report? < report)
      (++ safes)
      (if (safe-report? > report)
        (++ safes))))
  safes)

# Answers

(def ex-data (interpret ex-raw))
(def ex-answer-1 (answer-1 ex-data))
(def ex-answer-2 (answer-2 ex-data))

(def real-data (interpret real-raw))
(def real-answer-1 (answer-1 real-data))
(def real-answer-2 (answer-2 real-data))

# Output

(print "Part 1 is " real-answer-1)
(print "Part 2 is " real-answer-2)
