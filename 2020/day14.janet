(import spork/misc :as spork)

(defn parse-mask [m]
  (def res @[])
  (def mapping {48 0 49 1 88 nil})
  (loop [i :range [0 (length m)]]
    (put res i (mapping (m i))))
  res)

(def grammar
  ~{:main (some (* :mask :nl (group (some (* :mem :nl)))))
    :nl   (? "\n")
    :mask (* "mask = " (/ (<- (some (set "X01"))) ,parse-mask))
    :mem  (* "mem[" :addr "] = " :val)
    :addr (* (/ (<- :d+) ,scan-number))
    :val  (* (/ (<- :d+) ,scan-number))})

(defn dec-to-bin [n]
  (def res (array/new-filled 36 0))
  (var rem n)
  (var i 0)
  (while (> rem 0)
    (put res i (% rem 2))
    (set rem (math/floor (/ rem 2)))
    (++ i))
  (reverse res))

(defn bin-to-dec [n]
  (def reversed-n (reverse n))
  (var res 0)
  (loop [i :range [0 (length n)]]
    (+= res (case (reversed-n i)
              0 0
              1 (math/exp2 i))))
  res)

(defn mask-val [bin-val mask]
  (def res @[])
  (loop [i :range [0 (length bin-val)]]
    (case (mask i)
      0 (put res i 0)
      1 (put res i 1)
      (put res i (bin-val i))))
  (bin-to-dec res))

(defn init-1 [input]
  (def memory @{})
  (loop [[mask insts] :in (partition 2 input)
         [addr val] :in (partition 2 insts)]
    (def bin-val (dec-to-bin val))
    (def masked-val (mask-val bin-val mask))
    (put memory addr masked-val))
  memory)

(defn store [memory addr val pos]
  (if (< pos (length addr))
    (case (addr pos)
      "X" (loop [i :range [0 2]]
            (store memory (put addr pos i) val (inc pos))
            (put addr pos "X"))
      (store memory addr val (inc pos)))
    (put memory (bin-to-dec addr) val)))

(defn mask-addr [bin-val mask]
  (def res @[])
  (loop [i :range [0 (length bin-val)]]
    (case (mask i)
      0 (put res i (bin-val i))
      1 (put res i 1)
      (put res i "X")))
  res)

(defn init-2 [input]
  (def memory @{})
  (loop [[mask insts] :in (partition 2 input)
         [addr val] :in (partition 2 insts)]
    (def bin-addr (dec-to-bin addr))
    (def masked-addr (mask-addr bin-addr mask))
    (store memory masked-addr val 0))
  memory)

# Example

(def example1
  (->>
    ```
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    ```
    spork/dedent
    (peg/match grammar)))

(def example1-answer
  (->> (init-1 example1)
       values
       (apply +)))

(print "The sum of the values in memory is " example1-answer)

(def example2
  (->>
    ```
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    ```
    spork/dedent
    (peg/match grammar)))

(def example2-answer
  (->> (init-2 example2)
       (filter truthy?)
       (apply +)))

(print "The sum of the values in memory is " example2-answer)

# Part 1

(def part1-input
  (->> (slurp "day14.txt")
       (peg/match grammar)))

(def part1-answer
  (->> (init-1 part1-input)
       (filter truthy?)
       (apply +)))

(print "The sum of the values in memory is " part1-answer)

# Part 2

(def part2-answer
  (->> (init-2 part1-input)
       values
       (apply +)))

(print "The sum of the values in memory is " part2-answer)
