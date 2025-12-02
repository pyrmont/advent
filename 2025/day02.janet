(def ex-raw
  ```
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
  1698522-1698528,446443-446449,38593856-38593862,565653-565659,
  824824821-824824827,2121212118-2121212124
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (some (* :range (? ",") (? "\n")))
               :range (group (* (number :d+) "-" (number :d+)))}
             input))

(defn answer1
  [ranges]
  (def invalids @[])
  (each [begin end] ranges
    (loop [id :range [begin (inc end)]]
      (def maybe (string id))
      (def len (length maybe))
      (when (zero? (% len 2))
        (def half-len (/ len 2))
        (def front (string/slice maybe 0 half-len))
        (def back (string/slice maybe half-len))
        (when (= front back)
          (array/push invalids id)))))
  (reduce + 0 invalids))

(defn answer2
  [ranges]
  (def invalids @[])
  (each [begin end] ranges
    (loop [id :range [begin (inc end)]]
      (def maybe (string id))
      (def len (length maybe))
      (def half-len (math/ceil (/ len 2)))
      (def bit (% len 2))
      (loop [i :range [0 (math/ceil (/ len 3))]]
        (def front (string/slice maybe 0 (- half-len i bit)))
        (def back (string/slice maybe (+ half-len i)))
        (def middle (string/slice maybe (- half-len i bit) (+ half-len i)))
        (when (and (not (empty? front))
                   (= front back)
                   (= (string front middle)
                      (string middle back)))
          (array/push invalids id)
          (break)))))
  (reduce + 0 invalids))

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input))
(def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day02.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input))
(def real-answer2 (answer2 real-input))
