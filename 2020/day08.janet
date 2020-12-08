(import spork/misc :as spork)

(def grammar
  (peg/compile
    ~{:main (some (* :op :s :num :s*))
      :op (/ (<- :w+) ,keyword)
      :num (/ (<- (* (set "+-") :d+)) ,scan-number)}))

(defn execute [ops idx acc hist]
  (if (or (hist idx)            # instruction has been executed
          (nil? (get ops idx))) # end of instructions
    [idx acc hist]
    (let [[op num] (ops idx)
          new-hist (put hist idx true)]
      (case op
        :nop (execute ops (inc idx) acc new-hist)
        :acc (execute ops (inc idx) (+ acc num) new-hist)
        :jmp (execute ops (+ idx num) acc new-hist)))))

(defn flip-and-execute [ops idx]
  (when-let [[op num] (ops idx)
             new-op   (case op :nop :jmp :jmp :nop)
             _        (put ops idx [new-op num])
             res      (execute ops 0 0 @{})
             _        (put ops idx [op num])]
    res))

(defn search [ops]
  (def end (length ops))
  (var res nil)
  (loop [i :range [0 end]
           :until (and res
                       (= end (get res 0)))]
    (set res (flip-and-execute ops i)))
  res)

# Example

(def example
  (->>
    ```
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    ```
    spork/dedent
    (peg/match grammar)
    (partition 2)))

(def example-answer
  (-> (execute example 0 0 @{})
      (get 1)))

(print "Accumulator: " example-answer)

# Part 1

(def part1-input
  (->> (slurp "day08.txt")
       (peg/match grammar)
       (partition 2)))

(def part1-answer
  (-> (execute part1-input 0 0 @{})
      (get 1)))

(print "Accumulator: " part1-answer)

# Part 2

(def part2-answer
  (-> (search part1-input)
      (get 1)))

(print "Accumulator: " part2-answer)
