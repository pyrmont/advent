(import spork/misc :as spork)

(defn keywordise [str]
  (-> (string/replace-all " " "-" str) keyword))

(def grammar
  ~{:main (/ (* :rules :nl :mine :nl :others) ,struct)
    :nl   (? "\n")

    :number  (/ (<- :d+) ,scan-number)
    :numbers (group (* :number (any (* (? (* "," :number)))) :nl))
    :range   (group (* :s* (group (* :number "-" :number)) " or " (group (* :number "-" :number)) :nl))

    :rules  (* (constant ,:rules) (/ (some (* (/ (<- (some (+ :w+ " "))) ,keywordise) ":" :range)) ,struct))
    :mine   (* "your ticket:" (constant ,:mine) :s+ :numbers)
    :others (* "nearby tickets:" (constant ,:nearby) :s+ (group (some :numbers)))})

(defn is-invalid? [rules number]
  (var valid? false)
  (loop [ranges  :in (values rules)
         [lo hi] :in ranges
                 :until valid?]
    (when (<= lo number hi)
      (set valid? true)))
  (not valid?))

(defn collect-invalids [rules numbers]
  (var invalids @[])
  (loop [number :in numbers
                :when (is-invalid? rules number)]
     (array/push invalids number))
  invalids)

(defn contains? [ranges number]
  (def bot (ranges 1))
  (def top (ranges 0))
  (or (<= (bot 0) number (bot 1))
      (<= (top 0) number (top 1))))

(defn add [tbl x y]
  (when (nil? (tbl x))
    (put tbl x @[]))
  (when (nil? (tbl y))
    (put tbl y @[]))
  (array/push (tbl x) y)
  (array/push (tbl y) x))

(defn create-impossibles [rules valids]
  (def impossibles @{})
  (def rules-count (length (keys rules)))
  (def valids-count (length valids))
  (def fields-count (length (first valids)))
  (loop [i :range [0 valids-count]
         j :range [0 fields-count]
           :let [numbers (valids i)
                 number  (numbers j)]]
    (var stop? false)
    (loop [[name ranges] :pairs rules
                         :until stop?]
      (when (not (contains? ranges number))
        (add impossibles j name)
        (set stop? true))))
  impossibles)

(defn missing-number [numbers total]
  (def candidates (range 0 total))
  (find (fn [needle]
          (not (find |(= needle $) numbers)))
        candidates))

(defn missing-field [names rules]
  (def candidates (keys rules))
  (find (fn [needle]
          (not (find |(= needle $) names)))
        candidates))

(defn deduce-fields [rules valids impossibles]
  (var completed 0)
  (def rules-count (length (keys rules)))
  (def fields-count (length (first valids)))
  (def fields (array/new fields-count))
  (while (< completed fields-count)
    (eachp [k v] impossibles
      (case (type k)
        :keyword
        (when (= (inc (length v)) fields-count)
          (def number (missing-number v fields-count))
          (put fields number k)
          (eachp [k* v*] impossibles
            (when (= (type k*) :keyword)
              (array/push (impossibles k*) number)))
          (++ completed)
          (break))
        :number
        (when (= (inc (length v)) rules-count)
          (def field (missing-field v rules))
          (put fields k field)
          (eachp [k* v*] impossibles
            (when (= (type k*) :number)
              (array/push (impossibles k*) field)))
          (++ completed)
          (break)))))
  fields)

(defn get-fields [input]
  (def valids (filter |(empty? (collect-invalids (input :rules) $)) (input :nearby)))
  (->>
    (create-impossibles (input :rules) valids)
    (deduce-fields (input :rules) valids)))

# Example

(def example1
  (->>
    ```
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    ```
    spork/dedent
    (peg/match grammar)
    first))

(def example1-answer
  (->> (mapcat (partial collect-invalids (example1 :rules)) (example1 :nearby))
       (reduce + 0)))

(print "The ticket scanning error rate is " example1-answer)

(def example2
  (->>
    ```
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    ```
    spork/dedent
    (peg/match grammar)
    first))

(def example2-answer
  (get-fields example2))

(printf "The order of the fields is %j" example2-answer)

# Part 1

(def part1-input
  (->> (slurp "day16.txt")
       string/trim
       (peg/match grammar)
       first))

(def part1-answer
  (->> (part1-input :nearby)
       (mapcat |(collect-invalids (part1-input :rules) $))
       (reduce + 0)))

(print "The ticket scanning error rate is " part1-answer)

# Part 2

(def part2-answer
  (let [ks     (get-fields part1-input)
        ticket (zipcoll ks (part1-input :mine))]
    (var res 1)
    (eachp [k v] ticket
      (if (string/has-prefix? "departure" (string k))
        (set res (* res v))))
    res))

(print "The product of the values is " part2-answer)
