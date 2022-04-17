(require '[clojure.string :as str])
(require '[clojure.tools.trace :use all])
(require '[clojure.pprint :use [pprint]])
(require '[clojure.java.io :as io])
(require '[clojure.test :use all])

(def speccy-screen-lines
  [0x4000 0x4100 0x4200 0x4300 0x4400 0x4500 0x4600 0x4700
   0x4020 0x4120 0x4220 0x4320 0x4420 0x4520 0x4620 0x4720
   0x4040 0x4140 0x4240 0x4340 0x4440 0x4540 0x4640 0x4740
   0x4060 0x4160 0x4260 0x4360 0x4460 0x4560 0x4660 0x4760
   0x4080 0x4180 0x4280 0x4380 0x4480 0x4580 0x4680 0x4780
   0x40A0 0x41A0 0x42A0 0x43A0 0x44A0 0x45A0 0x46A0 0x47A0
   0x40C0 0x41C0 0x42C0 0x43C0 0x44C0 0x45C0 0x46C0 0x47C0
   0x40E0 0x41E0 0x42E0 0x43E0 0x44E0 0x45E0 0x46E0 0x47E0
   0x4800 0x4900 0x4A00 0x4B00 0x4C00 0x4D00 0x4E00 0x4F00
   0x4820 0x4920 0x4A20 0x4B20 0x4C20 0x4D20 0x4E20 0x4F20
   0x4840 0x4940 0x4A40 0x4B40 0x4C40 0x4D40 0x4E40 0x4F40
   0x4860 0x4960 0x4A60 0x4B60 0x4C60 0x4D60 0x4E60 0x4F60
   0x4880 0x4980 0x4A80 0x4B80 0x4C80 0x4D80 0x4E80 0x4F80
   0x48A0 0x49A0 0x4AA0 0x4BA0 0x4CA0 0x4DA0 0x4EA0 0x4FA0
   0x48C0 0x49C0 0x4AC0 0x4BC0 0x4CC0 0x4DC0 0x4EC0 0x4FC0
   0x48E0 0x49E0 0x4AE0 0x4BE0 0x4CE0 0x4DE0 0x4EE0 0x4FE0
   0x5000 0x5100 0x5200 0x5300 0x5400 0x5500 0x5600 0x5700
   0x5020 0x5120 0x5220 0x5320 0x5420 0x5520 0x5620 0x5720
   0x5040 0x5140 0x5240 0x5340 0x5440 0x5540 0x5640 0x5740
   0x5060 0x5160 0x5260 0x5360 0x5460 0x5560 0x5660 0x5760
   0x5080 0x5180 0x5280 0x5380 0x5480 0x5580 0x5680 0x5780
   0x50A0 0x51A0 0x52A0 0x53A0 0x54A0 0x55A0 0x56A0 0x57A0
   0x50C0 0x51C0 0x52C0 0x53C0 0x54C0 0x55C0 0x56C0 0x57C0
   0x50E0 0x51E0 0x52E0 0x53E0 0x54E0 0x55E0 0x56E0 0x57E0])

(def tile-defs
  [["t_wall_corner_ul" 0 0 :normal]
   ["t_wall_corner_ur" 0 0 :mirror-h]
   ["t_wall_corner_dl" 0 0 :mirror-v]
   ["t_wall_corner_dr" 0 0 :mirror-hv]])

(defn unsigned [b]
  (if (< b 0)
    (+ 256 b)
    b))

(defn read-speccy-screen [filename]
  (let [buffer (byte-array 6912)]
    (.read (io/input-stream filename) buffer)
    (mapv unsigned (vec buffer))))

(defn speccy-addr [x y]
  {:pre [(clojure.test/is (<= 0 x 255))
         (clojure.test/is (<= 0 y 191))]}
  (let [base-addr (nth speccy-screen-lines y)]
    (- (+ base-addr (quot x 8)) 0x4000)))

(defn speccy-attribute-addr [x y]
  {:pre [(clojure.test/is (<= 0 x 255))
         (clojure.test/is (<= 0 y 191))]}
  (+ 0x1800 (* 32 (quot y 8)) (quot x 8)))

(defn get-pixel [b pix]
  ;(println "reading " b " for " pix)
  (case (mod b 8)
    0 (> (bit-and pix 128) 0)
    1 (> (bit-and pix 64) 0)
    2 (> (bit-and pix 32) 0)
    3 (> (bit-and pix 16) 0)
    4 (> (bit-and pix 8) 0)
    5 (> (bit-and pix 4) 0)
    6 (> (bit-and pix 2) 0)
    7 (> (bit-and pix 1) 0)))

(defn speccy-pixel [x y buffer]
  (get-pixel x (get buffer (speccy-addr x y))))

(def Pixls
  {true "X", false "-"})

(def Colors
  {0 "black"
   1 "blue"
   2 "red"
   3 "magenta"
   4 "green"
   5 "cyan"
   6 "yellow"
   7 "white"
   })

(def Brights
  {true "on", false "off"})

(defn get-tile [[x y] buffer]
  (for [yy (range y (+ y 16))]
    (map Pixls (for [xx (range x (+ x 16))] 
                 (speccy-pixel xx yy buffer)))))

(def Work (read-speccy-screen "/proj/isaac/work.scr"))

(defn make-asm [tile name]
  (str/join "\n"
    (concat
      [(format "%s:" name)]
      (map #(format "        dg %s" (str/join "" %)) tile))))


(defn rotate-tile [t rotation]
  (case rotation
    :normal t
    :mirror-h (map reverse t)
    :mirror-v (reverse t)
    :mirror-hv (reverse (map reverse t))))

(defn make-attr-asm [[x y] buffer]
  (let [addr (speccy-attribute-addr x y)
        color (bit-and (get buffer addr) 7)
        paper (bit-and (bit-shift-right (get buffer addr) 3) 7)
        bright? (> (bit-and (get buffer addr) 0x40) 0)]
    (format "        db (Color.%s + Bg.%s + Bright.%s)"
            (Colors color)
            (Colors paper)
            (Brights bright?)
            addr)))

(defn flatten-attrs [[xs ys]]
  [(first xs) (second xs) (first ys) (second ys)])

(defn process-def-line [[name x y mode]]
  (let [tile (get-tile [x y] Work)
        tile-asm (make-asm (rotate-tile tile mode) name)
        attr-offsets (rotate-tile 
                       [[[(+ 0 x) (+ 0 y)] [(+ 8 x) (+ 0 y)]]
                        [[(+ 0 x) (+ 8 y)] [(+ 8 x) (+ 8 y)]]] mode)
        attrs-asms (mapv #(make-attr-asm % Work) (flatten-attrs attr-offsets))]
    (str/join "\n" (apply conj [tile-asm] attrs-asms))))






(defn main []
  (spit "/proj/isaac/src/gen.tiles.inc" (str/join "\n\n" (mapv process-def-line tile-defs))))

(main)
