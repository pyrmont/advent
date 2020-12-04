(import spork/misc :as spork)

(def passport-grammar
  (peg/compile
    ~{:ws  (+ "\n" " ")
      :ecl (* (/ (<- "ecl") ,keyword) ":" (<- (some :S)))
      :pid (* (/ (<- "pid") ,keyword) ":" (<- (some :S)))
      :eyr (* (/ (<- "eyr") ,keyword) ":" (<- (some :S)))
      :hcl (* (/ (<- "hcl") ,keyword) ":" (<- (some :S)))
      :byr (* (/ (<- "byr") ,keyword) ":" (<- (some :S)))
      :iyr (* (/ (<- "iyr") ,keyword) ":" (<- (some :S)))
      :cid (* (/ (<- "cid") ,keyword) ":" (<- (some :S)))
      :hgt (* (/ (<- "hgt") ,keyword) ":" (<- (some :S)))
      :main (some (+ :ws :ecl :pid :eyr :hcl :byr :iyr :cid :hgt))}))

(defn validate-lax [d]
   (and (struct? d)
        (d :ecl)
        (d :pid)
        (d :eyr)
        (d :hcl)
        (d :byr)
        (d :iyr)
        (d :hgt)))

(defn check-year [s [min-y max-y]]
  (def y (scan-number s))
  (and y (>= y min-y) (<= y max-y)))

(defn check-hgt [s [min-cm max-cm] [min-in max-in]]
  (def h-cm (-?> (peg/match '(* (<- :d+) "cm" -1) s) first scan-number))
  (def h-in (-?> (peg/match '(* (<- :d+) "in" -1) s) first scan-number))
  (or (and h-cm (>= h-cm min-cm) (<= h-cm max-cm))
      (and h-in (>= h-in min-in) (<= h-in max-in))))

(defn check-hcl [s]
  (peg/match '(* "#" (repeat 6 (+ :d (range "af"))) -1) s))

(defn check-ecl [s]
  (peg/match '(* (+ "amb" "blu" "brn" "gry" "grn" "hzl" "oth") -1) s))

(defn check-pid [s]
  (peg/match '(* (repeat 9 :d) -1) s))

(defn validate-strict [d]
  (and (validate-lax d)
       (-> (d :byr) (check-year [1920 2002]))
       (-> (d :iyr) (check-year [2010 2020]))
       (-> (d :eyr) (check-year [2020 2030]))
       (-> (d :hgt) (check-hgt [150 193] [59 76]))
       (-> (d :hcl) (check-hcl))
       (-> (d :ecl) (check-ecl))
       (-> (d :pid) (check-pid))))

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
    (string/split "\n\n")
    (map |(as-> $ x
                (peg/match passport-grammar x)
                (struct (splice x))))))

(def example-answer
  (count validate-lax example))

(print example-answer " valid documents")

# Part 1

(def part1-input
  (->>
    (slurp "day04.txt")
    string/trim
    (string/split "\n\n")
    (map |(as-> $ x
                (peg/match passport-grammar x)
                (when x (struct (splice x)))))))

(def part1-answer
  (count validate-lax part1-input))

(print part1-answer " valid documents")

# Part 2

(def part2-answer
  (count validate-strict part1-input))

(print part2-answer " valid documents")
