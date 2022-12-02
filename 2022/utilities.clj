(ns utilities
  (:require [clojure.string :as str]))

(defn- dedent
  [s n]
  (let [str-pat (clojure.core/str "(?m)^[ ]{" n "}")
        reg-pat (re-pattern str-pat)]
    (str/replace s reg-pat "")))

(defn trim-split
  "Trims the input s and dedents by n spaces"
  ([s]
   (->> (str/replace s #"^\n|\n+$" "")
        (str/split-lines)))
  ([s n]
   (->> (dedent s n)
        (trim-split))))
