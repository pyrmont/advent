(def grammar
  ~{:main (* :tile (any (* :nl :nl :tile)))
    :nl "\n"
    :tile (* :id :data)
    :id (* "Tile " (/ (<- :d+) ,scan-number) ":" :nl)
    :data (group (* :line (any (* :nl :line))))
    :line (<- (some (set ".#")))})

(defn get-sides [lines]
  (def height (length lines))
  (def limit (dec height))
  (def top (lines 0))
  (def bottom (lines limit))
  (def left (buffer/new height))
  (def right (buffer/new height))
  (loop [i :range [0 height]]
    (buffer/push-byte left (get-in lines [i 0]))
    (buffer/push-byte right (get-in lines [i limit])))
  [top bottom (string left) (string right)])

(defn get-candidates [tiles]
  (def res @{})
  (def id-and-sides (map (fn [tile]
                           (def [id lines] tile)
                           [id (get-sides lines)])
                         (pairs tiles)))
  (each [id sides] id-and-sides
    (loop [i :range [0 (length sides)]
             :let [side (sides i)
                   reversed (->> (reverse side) (apply string/from-bytes))]]
      (if (get res side) (array/push (get res side) [id (inc i)])
                         (put res side @[[id (inc i)]]))
      (if (get res reversed) (array/push (get res reversed) [id (* -1 (inc i))])
                             (put res reversed @[[id (* -1 (inc i))]]))))
  (filter |(> (length $) 1) res))

(defn get-corners [combinations]
  (def res @{})
  (each [[x-id x-side] [y-id y-side]] combinations
    (if (get res x-id) (array/push (get res x-id) x-side)
                       (put res x-id @[x-side]))
    (if (get res y-id) (array/push (get res y-id) y-side)
                       (put res y-id @[y-side])))
  (filter |(= (length ($ 1)) 4) (pairs res)))

# Example

(def example
  (->> (slurp "day20-example.txt")
       (peg/match grammar)
       (apply struct)))

(def example-answer
  (->> (get-candidates example)
       get-corners
       (reduce |(* $0 ($1 0)) 1)))

(print "The product of the corner IDs is " example-answer)

# # Part 1

(def part1-input
  (->> (slurp "day20.txt")
       (peg/match grammar)
       (apply struct)))

(def part1-answer
  (->> (get-candidates part1-input)
       get-corners
       (reduce |(* $0 ($1 0)) 1)))

(print "The product of the corner IDs is " part1-answer)
