(import spork/misc :as spork)

(defn make-grammar [arranging-fn]
  ~{:ws " "
    :quantity (* (/ (<- :d+) ,scan-number) :ws)
    :modifier :w+
    :colour :w+
    :quality (* (<- (* :modifier :ws :colour)) :ws)
    :contain " contain "
    :bags (+ "bags" "bag")
    :outer-bags (* :quality :bags)
    :inner-bag (+ (* :quantity :quality :bags) "no other bags")
    :inner-bags (group (* :inner-bag (any (* ", " :inner-bag))))
    :main (/ (some (* :outer-bags :contain :inner-bags "." (? "\n"))) ,arranging-fn)})

# Functions for outside counting

(defn arrange-by-inner [& bags]
  (def res @{})
  (each [outer-bag inner-bags] (partition 2 bags)
    (each [_ inner-bag] (partition 2 inner-bags)
      (if-let [outer-bags (get res inner-bag)]
        (array/push outer-bags outer-bag)
        (put res inner-bag @[outer-bag]))))
  res)

(defn list-outer-bags [results bag bags]
  (when-let [outer-bags (get bags bag)]
    (each outer-bag outer-bags
      (unless (get results outer-bag)
        (put results outer-bag true)
        (list-outer-bags results outer-bag bags))))
  results)

(defn count-outer-bags [bag rules]
  (->> (peg/match (make-grammar arrange-by-inner) rules)
       first
       (list-outer-bags @{} bag)
       keys
       length))

# Functions for inside counting

(defn arrange-by-outer [& bags]
  (apply struct bags))

(defn count-inner-bags* [bag bags]
  (var res 0)
  (when-let [inner-bags (get bags bag)]
    (each [quantity quality] (partition 2 inner-bags)
      (+= res quantity)
      (+= res (* quantity (count-inner-bags* quality bags)))))
  res)

(defn count-inner-bags [bag rules]
  (->> (peg/match (make-grammar arrange-by-outer) rules)
       first
       (count-inner-bags* bag)))

# Examples

(def example
  (->>
    ```
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    ```
    spork/dedent))

(def example1-answer
  (count-outer-bags "shiny gold" example))

(def example2-answer
  (count-inner-bags "shiny gold" example))

# Part 1

(def part1-input
  (-> (slurp "day07.txt") string/trim))

(def part1-answer
  (count-outer-bags "shiny gold" part1-input))

# Part 2

(def part2-answer
  (count-inner-bags "shiny gold" part1-input))
