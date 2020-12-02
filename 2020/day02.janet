(def password-db (slurp "day02.txt"))

(def input
  (->> (string/trim password-db)
       (string/replace-all ":" "")
       (string/split "\n")
       (map |(string/split " " $))))

# Part 1

(defn check-password-1 [rnge letter pw]
  (let [[lo hi] (->> (string/split "-" rnge) (map scan-number))
        c       (first (string/bytes letter))
        cnt     (count |(= c $) pw)
        result  (and (>= cnt lo) (<= cnt hi))]
    result))

(-> (fn [x] (apply check-password-1 x))
    (filter input)
    length
    print)

# Part 2

(defn check-password-2 [rnge letter pw]
  (let [[x y]   (->> (string/split "-" rnge) (map scan-number))
        c       (first (string/bytes letter))
        at-x    (in pw (- x 1))
        at-y    (in pw (- y 1))
        result  (or (and (= c at-x)    (not= c at-y))
                    (and (not= c at-x) (= c at-y)))]
    result))

(-> (fn [x] (apply check-password-2 x))
    (filter input)
    length
    print)
