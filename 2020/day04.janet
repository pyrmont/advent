(import spork/misc :as spork)

(defn check-byr [s]
  (<= 1920 (scan-number s) 2002))

(defn check-iyr [s]
  (<= 2010 (scan-number s) 2020))

(defn check-eyr [s]
  (<= 2020 (scan-number s) 2030))

(defn check-hgt [s-h s-u]
  (case s-u
    "cm" (<= 150 (scan-number s-h) 193)
    "in" (<= 59 (scan-number s-h) 76)))

(def passport-grammar-strict
  (peg/compile
    ~{:ws  (+ "\n" " ")
      :byr (* (/ (<- "byr") ,keyword) ":" (cmt (<- (repeat 4 :d)) ,check-byr))
      :iyr (* (/ (<- "iyr") ,keyword) ":" (cmt (<- (repeat 4 :d)) ,check-iyr))
      :eyr (* (/ (<- "eyr") ,keyword) ":" (cmt (<- (repeat 4 :d)) ,check-eyr))
      :hgt (* (/ (<- "hgt") ,keyword) ":" (cmt (* (<- :d+) (<- (+ "cm" "in"))) ,check-hgt))
      :hcl (* (/ (<- "hcl") ,keyword) ":" (<- (* "#" (repeat 6 (+ (range "09") (range "af"))))))
      :ecl (* (/ (<- "ecl") ,keyword) ":" (<- (+ "amb" "blu" "brn" "gry" "grn" "hzl" "oth")))
      :pid (* (/ (<- "pid") ,keyword) ":" (<- (repeat 9 :d)))
      :cid (* (/ (<- "cid") ,keyword) ":" (<- (some :S)))
      :main (/ (some (+ :ws :byr :iyr :eyr :hgt :hcl :ecl :pid :cid)) ,struct)}))

(def passport-grammar
  (peg/compile
    ~{:ws  (+ "\n" " ")
      :byr (* (/ (<- "byr") ,keyword) ":" (<- (some :S)))
      :iyr (* (/ (<- "iyr") ,keyword) ":" (<- (some :S)))
      :eyr (* (/ (<- "eyr") ,keyword) ":" (<- (some :S)))
      :hgt (* (/ (<- "hgt") ,keyword) ":" (<- (some :S)))
      :hcl (* (/ (<- "hcl") ,keyword) ":" (<- (some :S)))
      :ecl (* (/ (<- "ecl") ,keyword) ":" (<- (some :S)))
      :pid (* (/ (<- "pid") ,keyword) ":" (<- (some :S)))
      :cid (* (/ (<- "cid") ,keyword) ":" (<- (some :S)))
      :main (/ (some (+ :ws :byr :iyr :eyr :hgt :hcl :ecl :pid :cid)) ,struct)}))

(defn validate [d]
   (and (struct? d)
        (d :ecl)
        (d :pid)
        (d :eyr)
        (d :hcl)
        (d :byr)
        (d :iyr)
        (d :hgt)))

# Example

(def example
  (->>
    ```
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    ```
    spork/dedent
    string/trim
    (string/split "\n\n")))

(def example-answer
  (->> (mapcat |(peg/match passport-grammar $) example)
       (count validate)))

(print example-answer " valid documents")

# Part 1

(def part1-input
  (->>
    (slurp "day04.txt")
    string/trim
    (string/split "\n\n")))

(def part1-answer
  (->> (mapcat |(peg/match passport-grammar $) part1-input)
       (count validate)))

(print part1-answer " valid documents")

# Part 2

(def part2-answer
  (->> (mapcat |(peg/match passport-grammar-strict $) part1-input)
       (count validate)))

(print part2-answer " valid documents")
