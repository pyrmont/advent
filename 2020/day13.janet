(import spork/misc :as spork)

(def grammar-1
  ~{:main (* :start :nl :buses)
    :nl "\n"
    :start (/ (<- :d+) ,scan-number)
    :buses (group (some (* (+ :bus "x") (? ","))))
    :bus (/ (<- :d+) ,scan-number)})

(def grammar-2
  ~{:main :buses
    :buses (some (* (+ :bus :any) (? ",")))
    :bus (/ (<- :d+) ,scan-number)
    :any (/ (<- "x") ,:any)})

(defn get-next-ones [start buses]
  (def next-ones @[])
  (each bus buses
    (array/push next-ones [bus (-> (/ start bus)
                                   math/ceil
                                   (* bus))]))
  next-ones)

(defn get-best-bus [start buses]
  (def next-ones (get-next-ones start buses))
  (first (sort-by |(get $ 1) next-ones)))

(defn get-buses-and-offsets [input]
  (def ordering (peg/match grammar-2 input))
  (def buses @[])
  (loop [i :range [0 (length ordering)]
           :when (not= :any (ordering i))]
    (array/push buses [(ordering i) i]))
  buses)

(defn get-ts [buses-and-offsets]
  (var ts 0)
  (var step 1)
  (loop [[bus offset] :in buses-and-offsets]
    (while (not (zero? (% (+ ts offset) bus)))
      (+= ts step))
    (*= step bus))
  ts)

# Example

(def example
  (->>
    ```
    939
    7,13,x,x,59,x,31,19
    ```
    spork/dedent))

(def example-answer1
  (let [[start buses] (peg/match grammar-1 example)
        [bus arrival] (get-best-bus start buses)]
    (* bus (- arrival start))))

(print "The ID multiplied by the minutes to wait is " example-answer1)

# Part 1

(def part1-input
  (-> (slurp "day13.txt")
      string/trim))

(def part1-answer
  (let [[start buses] (peg/match grammar-1 part1-input)
        [bus arrival] (get-best-bus start buses)]
    (* bus (- arrival start))))

(print "The ID multiplied by the minutes to wait is " part1-answer)

# Part 2

(def example-answer2
  (->> (string/split "\n" example)
       last
       get-buses-and-offsets
       get-ts))

(print "The timestamp that meets the requirements is " example-answer2)

(def part2-answer
  (->> (string/split "\n" part1-input)
       last
       get-buses-and-offsets
       get-ts))

(print "The timestamp that meets the requirements is " part2-answer)
