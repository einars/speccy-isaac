(require '[clojure.string :as str])
(require '[clojure.tools.trace :use all])
(require '[clojure.pprint :use [pprint]])


(defn multi-concat [accums ys]
  (map #(conj %1 (apply str %2)) accums ys))

(defn split-to-columns [lines]
  (let [ls (mapv #(partition-all 8 %) lines)]
    (reduce multi-concat (map (constantly []) (first ls)) ls)))


(defn make-pixel-char [c]
  (condp = c
    \- 0
    \. 0
    \0 1
    (assert false)))

(defn make-mask-char [c]
  (condp = c
    \- 1
    \. 0
    \0 0
    (assert false)))

(defn make-pixels [column]
  (map #(map make-pixel-char %) column))

(defn make-mask [column]
  (map #(map make-mask-char %) column))

(defn read-sprite [s]
  (let [lines (str/split s #"\n")
        k (first lines)
        image-data (rest lines)
        columns (split-to-columns image-data)]
    {:label k
     :columns columns
     :pixels (map make-pixels columns)
     :masks (map make-mask columns)
     :width-chars (/ (count (first image-data)) 8)
     :height-pixels (count image-data)}))

(defn binary-s [bs]
  (format "0b%s" (str/join "" bs)))

(defn column-to-string [pix-col mask-col]
  (str/join
    "\n"
    (concat
      [(format "                db %d" (count pix-col))]
      (map (fn [[pix mask]]
             (format "                db %s, %s" (binary-s mask) (binary-s pix)))
           (partition-all 2 (interleave pix-col mask-col)))
      )))

(defn sprite-to-string [{:keys [label pixels masks width-chars height-pixels]}]
  (let [label (str/replace label "." "_")
        asm (if (= 1 width-chars)
              (column-to-string (first pixels) (first masks))
              (str/join "\n\n"
                        (mapv
                          (fn [[pix mask]] (column-to-string pix mask))
                          (partition-all 2 (interleave pixels masks))
                          )))]
    (format "%s:\n%s\n                db 0" label asm))) ; end flag




(defn materialize [sprites f]
  (spit f (str/join "\n\n" (map sprite-to-string sprites))))


(defn read-sprites [f]
  (->>
    (str/split (slurp f) #"\n\n")
    (map read-sprite)))

(materialize (read-sprites "/proj/isaac/src/sprites.txt")
             "/proj/isaac/src/generated-sprites.asm")
