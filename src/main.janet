(import circlet)

(defn static-response [name mime] {
    :status 200
    :kind :file
    :file (string "static/" name)
    :mime mime
})
(def core-static-files {
    "/favicon.ico" (static-response "favicon.ico" "image/x-icon")
    "/robots.txt" (static-response "robots.txt" "text/plain")
    "/index.html" (static-response "index.html" "text/html")
    "/video.html" (static-response "video.html" "text/html")
    "/audio.html" (static-response "audio.html" "text/html")
    "/lottie.html" (static-response "lottie.html" "text/html")
    "/video" (static-response "video.html" "text/html")
    "/audio" (static-response "audio.html" "text/html")
    "/image" (static-response "index.html" "text/html")
    "/lottie" (static-response "lottie.html" "text/html")
    "/lottie.min.js" (static-response "lottie.min.js" "application/javascript")
    "/style.css" (static-response "style.css" "text/css")
})

(def static-files {
    "/bread.aac" (static-response "bread.aac" "audio/aac")
    "/bread.avif" (static-response "bread.avif" "image/avif")
    "/bread.bmp" (static-response "bread.bmp" "image/bmp")
    "/bread.c" (static-response "bread.c" "text/plain")
    "/bread.cpp" (static-response "bread.cpp" "text/plain")
    "/bread.css" (static-response "bread.css" "text/css")
    "/bread.csv" (static-response "bread.css" "text/csv")
    "/bread.flv" (static-response "bread.flv" "video/x-flv")
    "/bread.gif" (static-response "bread.gif" "image/gif")
    "/bread.jpg" (static-response "bread.jpg" "image/jpeg")
    "/bread.js" (static-response "bread.js" "application/javascript")
    "/bread.json" (static-response "bread.json" "application/json")
    "/bread.jxl" (static-response "bread.jxl" "image/jxl")
    "/bread.lottie.gif" (static-response "bread.lottie.gif" "image/gif")
    "/bread.lottie.json" (static-response "bread.lottie.json" "application/json")
    "/bread.m4a" (static-response "bread.m4a" "audio/m4a")
    "/bread.mp3" (static-response "bread.mp4" "audio/mpeg")
    "/bread.mp4" (static-response "bread.mp4" "video/mp4")
    "/bread.ogg" (static-response "bread.ogg" "audio/ogg")
    "/bread.ogv" (static-response "bread.ogv" "video/ogv")
    "/bread.pdf" (static-response "bread.pdf" "application/pdf")
    "/bread.png" (static-response "bread.png" "image/png")
    "/bread.rs" (static-response "bread.rs" "text/plain")
    "/bread.sh" (static-response "bread.sh" "text/plain")
    "/bread.sql" (static-response "bread.sql" "text/plain")
    "/bread.svg" (static-response "bread.svg" "image/svg+xml")
    "/bread.swf" (static-response "bread.swf" "application/x-shockwave-flash")
    "/bread.tgs" (static-response "bread.tgs" "application/octet-stream")
    "/bread.toml" (static-response "bread.toml" "text/plain")
    "/bread.txt" (static-response "bread.txt" "text/plain")
    "/bread.webm" (static-response "bread.webm" "video/webm")
    "/bread.webp" (static-response "bread.webp" "image/webp")
    "/bread.wp2" (static-response "bread.wp2" "image/wp2")
    "/bread.xml" (static-response "bread.xml" "text/xml")
    "/bread.yml" (static-response "bread.yml" "text/plain")
    "/bread.zst" (static-response "bread.zst" "application/zstd")
})
(def content-type-mapping {
    "application/x-yaml" (static-response "bread.yml" "text/plain")
    "application/toml" (static-response "bread.toml" "text/plain")
    "application/x-sh" (static-response "bread.sh" "text/plain")
    "application/sql" (static-response "bread.sql" "text/plain")
    "text/x-c++src" (static-response "bread.cpp" "text/plain")
    "text/x-csrc" (static-response "bread.c" "text/plain")
})

(def content-types (do
    (def mapping @{})
    (each uri (keys static-files)
        (def resp (get static-files uri))
        (unless (= "text/plain" (get resp :mime))
            (put mapping (get resp :mime) resp)
            ))
    (freeze mapping)
))

(defn app
    [request]
    (def uri (get request :uri))
    (var file (get core-static-files uri))
    (unless file
        # Content negotiation
        (def accept (get-in request [:headers "Accept"]))
        (when (and accept (not (string/has-prefix? "text/html" accept)))
            (each content-type (string/split "," accept)
                (def content-type (get (string/split ";" content-type) 0))
                (unless file
                    (var resp (get content-type-mapping content-type))
                    (unless resp
                        (set resp (get content-types content-type))
                        )
                    (when resp
                        (printf "Content negotiated %s" uri)
                        (set file resp))
                ))))
    # No core match
    # No content type match
    (unless file (when uri
        (set file (get static-files uri))
        ))
    (printf "%s %s" (get request :method) (get request :uri))
    (cond
        file file
        (= "/" uri) (static-response "index.html" "text/html")
        true {
            :status 404
            :body "Not Found"
        }
    )
    )

(defn main [& args]
    (let [port (scan-number (get args 1 (or (os/getenv "PORT") "8000")))
          host (get args 2 (or (os/getenv "HOST") "localhost"))
        ]
        (printf "Listening on %s:%d" host port)
        (circlet/server app port host)
    ))
