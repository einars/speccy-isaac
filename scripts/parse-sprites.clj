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
    (do
      (printf "What is this: [%c]?\n" c)
      (flush)
      (assert false))))

(defn make-mask-char [c]
  (condp = c
    \- 1
    \. 0
    \0 0
    (do
      (printf "What is this: [%c]?\n" c)
      (flush)
      (assert false))))

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
         (partition-all 2 (interleave pix-col mask-col))))))

(defn two-columns-to-string [[p1 p2] [m1 m2]]
  (str/join
   "\n"
   (concat
    [(format "                db %d" (count p1))] ; height
    (map (fn [[pa pb ma mb]]
           (format "                db %s, %s, %s, %s"
                   (binary-s ma)
                   (binary-s mb)
                   (binary-s pa)
                   (binary-s pb)))
         (partition-all 4 (interleave p1 p2 m1 m2))))))

(defn tile-to-string [{:keys [label pixels] :as s}]
  (let [label (str/replace label "." "_")
        [p1 p2] pixels
        asm (map (fn [pa pb]
                   (format "            db %s, %s"
                           (binary-s pa)
                           (binary-s pb)))
                 p1
                 p2)]
    (format "%s:\tdb %d\n%s\n"
            label
            (count (first pixels))
            (str/join "\n" asm))))

(defn sprite-to-string [{:keys [label pixels masks width-chars] :as s}]
  (if (str/starts-with? label "tile")
    (tile-to-string s)
    (let [label (str/replace label "." "_")
          asm (cond
                (= 1 width-chars)
                (column-to-string (first pixels) (first masks))

                (= 2 width-chars)
                (two-columns-to-string pixels masks)

                :else
                ; custom width
                (str/join "\n\n"
                          (mapv
                           (fn [[pix mask]] (column-to-string pix mask))
                           (partition-all 2 (interleave pixels masks)))))]
      (format "%s:\tdb (Sprite.Flags.double_column | Sprite.Flags.masked)\n%s" label asm)))) ; end flag

(defn materialize [sprites f]
  (spit f (str/join "\n\n" (map sprite-to-string sprites))))

(defn read-sprites [f]
  (->>
   (str/split (slurp f) #"\n\n")
   (map read-sprite)))

(materialize (read-sprites "/proj/isaac/src/sprites.txt")
             "/proj/isaac/src/gen.sprites.inc")
