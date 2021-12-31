(import halo2)
(import janet-html :as "html")
(import ./build/_bread)

(defn static-response [name mime] {
    :status 200
    :kind :file
    :file (string "static/" name)
    :headers {
        "Content-Type" mime
    }
})

(def extensions {
    "aac" "audio/aac"
    "avif" "image/avif"
    "bmp" "image/bmp"
    "css" "text/css"
    "csv" "text/csv"
    "flv" "video/x-flv"
    "gif" "image/gif"
    "html" "text/html"
    "ico" "image/x-icon"
    "jpg" "image/jpeg"
    "js" "application/javascript"
    "json" "application/json"
    "jxl" "image/jxl"
    "m4a" "audio/m4a"
    "mp3" "audio/mpeg"
    "mp4" "video/mp4"
    "ogg" "audio/ogg"
    "ogv" "video/ogv"
    "pdf" "application/pdf"
    "png" "image/png"
    "py" "text/x-python"
    "svg" "image/svg+xml"
    "swf" "application/x-shockwave-flash"
    "tgs" "application/octet-stream"
    "txt" "text/plain"
    "webm" "video/webm"
    "webp" "image/webp"
    "wp2" "image/wp2"
    "xml" "text/xml"
    "zst" "application/zstd"
})

(defn loaded-files [] (do
    (def result @{})
    (each file (os/dir "static/")
        (def ext (last (string/split "." file)))
        (var content-type (get extensions ext))
        (unless content-type
            (var bytes false)
            (with [f (file/open (string "static/" file))]
                (def head (file/read f 1024))
                # (printf "Binary detect %s" file)
                (if (_bread/is-binary head)
                    (set content-type "application/octet-stream")
                    (set content-type "text/plain")
                    )
                )
            )
        # (printf "file %s content type %p" file content-type)
        (when content-type
            (put result (string "/" file) (static-response file content-type))
            )
        )
    (freeze result)))

(def core-static-files {
    # "/" (static-response "index.html" "text/html")
    # "/video" (static-response "video.html" "text/html")
    # "/audio" (static-response "audio.html" "text/html")
    # "/image" (static-response "index.html" "text/html")
    # "/lottie" (static-response "lottie.html" "text/html")
    # "/test" (static-response "test.html" "text/html")
    "/version" (static-response "version.txt" "text/plain")
})

(def content-type-mapping {
    "application/x-yaml" (static-response "bread.yml" "text/plain")
    "application/toml" (static-response "bread.toml" "text/plain")
    "application/x-sh" (static-response "bread.sh" "text/plain")
    "application/sql" (static-response "bread.sql" "text/plain")
    "text/x-c++src" (static-response "bread.cpp" "text/plain")
    "text/x-csrc" (static-response "bread.c" "text/plain")
})

(defn opengraph-meta [uri title desc] [
    [:meta {:property "og:type" :content "website"}]
    [:meta {:property "og:title" :content title}]
    [:meta {:property "og:description" :content desc}]
    [:meta {:property "og:url" :content (string "https://bread.cendyne.dev" uri)}]
])
(def opengraph-image [
    [:meta {:property "og:image" :content "https://bread.cendyne.dev/bread.gif"}]
    [:meta {:property "og:image:secure_url" :content "https://bread.cendyne.dev/bread.gif"}]
    [:meta {:property "og:image:width" :content "512"}]
    [:meta {:property "og:image:height" :content "512"}]
])
(def opengraph-video [
    [:meta {:property "og:video" :content "https://bread.cendyne.dev/bread.mp4"}]
    [:meta {:property "og:video:secure_url" :content "https://bread.cendyne.dev/bread.mp4"}]
    [:meta {:property "og:video:type" :content "video/mp4"}]
    [:meta {:property "og:video:width" :content "512"}]
    [:meta {:property "og:video:height" :content "512"}]
])
(def twitter-card [
    [:meta {:name "twitter:domain" :content "cendyne.dev"}]
    [:meta {:name "twitter:url" :content "https://cendyne.dev"}]
    [:meta {:name "twitter:card" :content "player"}]
    [:meta {:name "twitter:title" :content "Feed Glitch Bread"}]
    [:meta {:name "twitter:description" :content "It's dangerous to go alone! Take this baguette."}]
    [:meta {:name "twitter:image" :content "https://bread.cendyne.dev/bread.gif"}]
    [:meta {:name "twitter:player" :content "https://bread.cendyne.dev/video"}]
    [:meta {:name "twitter:player:width" :content "512"}]
    [:meta {:name "twitter:player:height" :content "512"}]
    [:meta {:name "twitter:player:stream" :content "https://bread.cendyne.dev/bread.mp4"}]
    [:meta {:name "twitter:player:stream:content_type" :content "video/mp4"}]
    [:meta {:name "twitter:creator" :content "@CendyneNaga"}]
])
(def picture [
    [:picture
        [:source {:type "image/avif" :src "bread.avif"}]
        [:source {:type "image/wp2" :src "bread.wp2"}]
        [:source {:type "image/jxl" :src "bread.jxl"}]
        [:source {:type "image/webp" :src "bread.webp"}]
        [:img {:src "bread.gif" :alt "baguette" :width "512" :height "512"}]
    ]
])
(def video [
    [:video {:width "512" :height "512" :loop :boolean-attribute? :controls :boolean-attribute? :autoplay :boolean-attribute?}
        [:source {:type "video/webm" :src "bread.webm"}]
        [:source {:type "video/mp4" :src "bread.mp4"}]
        [:source {:type "video/ogv" :src "bread.ogv"}]
        [:img {:src "bread.gif" :alt "baguette" :width "512" :height "512"}]
    ]
])
(def audio [
    [:audio {:loop :boolean-attribute? :controls :boolean-attribute? :autoplay :boolean-attribute?}
        [:source {:type "audio/m4a" :src "bread.m4a"}]
        [:source {:type "audio/ogg" :src "bread.ogg"}]
        [:source {:type "audio/aac" :src "bread.aac"}]
        [:source {:type "audio/mpeg" :src "bread.mp3"}]
        [:img {:src "bread.gif" :alt "baguette" :width "512" :height "512"}]
    ]
])

(defn page [uri title desc head body]
    [
        (html/doctype :html5)
        [:html
            [:head
                [:title title]
                (opengraph-meta uri title desc)
                head
                [:meta {:name "theme-color" :content "#ff7700"}]
                [:link {:rel "stylesheet" :href "/style.css"}]
            ]
        ]
        [:body
            [:div {:class "container"}
                [:div {:class "content"}
                    body
                ]
            ]
        ]
    ]
)

(defn ua-page [request title desc content]
    # (printf "%p" request)
    (def uri (get request :uri))
    (var ua (get-in request [:headers "User-Agent"]))
    (unless ua (set ua (get-in request [:headers "user-agent"])))
    (html/encode (page uri title desc
        [
            (opengraph-meta uri title desc)
            opengraph-image
            opengraph-video
            (when (and ua (string/find "Twitterbot" ua)) twitter-card)
        ]
        content)))
(def title "Feed Glitch Bread")
(def description "It's dangerous to go alone! Take this baguette.")
(def other-formats [
    ["/" "image"]
    ["/audio" "audio"]
    ["/video" "video"]
    ["/lottie" "lottie"]
    ["/bread.svg" "SVG"]
    ["/bread.json" "JSON"]
    ["/bread.rs" "Rust"]
])
(defn other-formats-list [except] [
    "Other formats: "
    (seq [format :in other-formats
        :let [[href label] format]
        :when (not= except href)]
        [[:a {:href href} label] " "])
    " and more"
])
(defn index-page [request]
    (ua-page request title description [
        picture
        [:hr]
        (other-formats-list (get request :uri))
    ]))
(defn video-page [request]
    (ua-page request title description [
        video
        [:hr]
        (other-formats-list (get request :uri))
    ]))
(defn audio-page [request]
    (ua-page request title description [
        audio
        [:hr]
        (other-formats-list (get request :uri))
    ]))
(defn lottie-page [request]
    (ua-page request title description [
        [:div {:id "sticker"}]
        [:script {:src "lottie.min.js"}]
        [:script {:src "bread.lottie.js"}]
        [:hr]
        (other-formats-list (get request :uri))
    ]))

(defn app
    [files request]
    (def uri (get request :uri))
    (var file nil)
    (when uri
        (set file (get core-static-files uri))
        (unless file (set file (get files uri)))
        )
    (printf "%s %s" (get request :method) (get request :uri))
    (cond
        file file
        (= "/" uri) {
            :headers {
                "Content-Type" "text/html"
            }
            :body (index-page request)
        }
        (= "/video" uri) {
            :headers {
                "Content-Type" "text/html"
            }
            :body (video-page request)
        }
        (= "/audio" uri) {
            :headers {
                "Content-Type" "text/html"
            }
            :body (audio-page request)
        }
        (= "/lottie" uri) {
            :headers {
                "Content-Type" "text/html"
            }
            :body (lottie-page request)
        }
        true {
            :status 404
            :body "Not Found"
        }
    ))



(defn main [& args]
    (let [port (scan-number (get args 1 (or (os/getenv "PORT") "8000")))
          host (get args 2 (or (os/getenv "HOST") "localhost"))
        ]
        (printf "Listening on %s:%d" host port)
        (def files (loaded-files))
        (defn loaded-app [request] (app files request))
        (halo2/server loaded-app port host)
    ))
