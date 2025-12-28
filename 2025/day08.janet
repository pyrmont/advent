(def ex-raw
  ```
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
  ```)

(defn interpret
  [input]
  (peg/match ~{:main (* (some :coords))
               :coords (group (* :x "," :y "," :z (? :nl)))
               :coord (number :d+)
               :x :coord
               :y :coord
               :z :coord
               :nl "\n"}
             input))

(defn distance
  [[x1 y1 z1] [x2 y2 z2]]
  (def dx (- x2 x1))
  (def dy (- y2 y1))
  (def dz (- z2 z1))
  (math/sqrt (+ (* dx dx) (* dy dy) (* dz dz))))

(defn make-union-find
  [n]
  @{:parent (seq [i :range [0 n]] i)  # Each element is its own parent initially
    :size (seq [i :range [0 n]] 1)})   # Each set has size 1 initially

(defn find-root
  "Find the root of element x with path compression"
  [uf x]
  (def parent (get-in uf [:parent x]))
  (if (= parent x)
    x
    (do
      (def root (find-root uf parent))
      (put-in uf [:parent x] root)  # Path compression
      root)))

(defn union
  "Union two sets containing x and y, return true if they were different sets"
  [uf x y]
  (def root-x (find-root uf x))
  (def root-y (find-root uf y))
  (if (= root-x root-y)
    false  # Already in same set
    (do
      # Union by size - attach smaller tree to larger tree
      (def size-x (get-in uf [:size root-x]))
      (def size-y (get-in uf [:size root-y]))
      (if (< size-x size-y)
        (do
          (put-in uf [:parent root-x] root-y)
          (put-in uf [:size root-y] (+ size-x size-y)))
        (do
          (put-in uf [:parent root-y] root-x)
          (put-in uf [:size root-x] (+ size-x size-y))))
      true)))  # Successfully merged different sets

(defn get-circuit-sizes
  [uf n]
  (def root-sizes @{})
  (loop [i :range [0 n]]
    (def root (find-root uf i))
    (put root-sizes root (get-in uf [:size root])))
  (values root-sizes))

(defn answer1
  [boxes num-connections]
  (def n (length boxes))
  # Calculate all pairwise distances
  (def edges @[])
  (loop [i :range [0 n]
         j :range [(inc i) n]]
    (def dist (distance (boxes i) (boxes j)))
    (array/push edges [dist i j]))
  # Sort edges by distance
  (sort-by first edges)
  # Create Union-Find structure
  (def uf (make-union-find n))
  # Connect the closest pairs
  (var connections-made 0)
  (each [dist i j] edges
    (if (< connections-made num-connections)
      (do
        # Try to union, even if already in same circuit
        (union uf i j)
        (++ connections-made))
      (break)))
  # Get all circuit sizes
  (def sizes (sort (values (get-circuit-sizes uf n)) >))
  # Multiply the three largest
  (* (sizes 0) (sizes 1) (sizes 2)))

(defn answer2
  [boxes]
  (def n (length boxes))
  # Calculate all pairwise distances
  (def edges @[])
  (loop [i :range [0 n]
         j :range [(inc i) n]]
    (def dist (distance (boxes i) (boxes j)))
    (array/push edges [dist i j]))
  # Sort edges by distance
  (sort-by first edges)
  # Create Union-Find structure
  (def uf (make-union-find n))
  # Connect pairs until all are in one circuit
  (var last-connection nil)
  (each [dist i j] edges
    (when (union uf i j)
      # Only record connections that actually merged two different sets
      (set last-connection [i j])
      # Check if all boxes are in one circuit
      (def root (find-root uf 0))
      (when (= (get-in uf [:size root]) n)
        (break))))
  # Get the X coordinates of the last connection
  (def [i j] last-connection)
  (def x1 (get-in boxes [i 0]))
  (def x2 (get-in boxes [j 0]))
  (* x1 x2))

(def ex-input (interpret ex-raw))
(def ex-answer1 (answer1 ex-input 10))
(def ex-answer2 (answer2 ex-input))

(def real-raw (slurp "day08.input"))

(def real-input (interpret real-raw))
(def real-answer1 (answer1 real-input 1000))
(def real-answer2 (answer2 real-input))
