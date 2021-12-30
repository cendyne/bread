(import circlet)
(import ./build/_bread)

(defn static-response [name mime] {
    :status 200
    :kind :file
    :file (string "static/" name)
    :mime mime
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
                (printf "Binary detect %s" file)
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
    "/" (static-response "index.html" "text/html")
    "/video" (static-response "video.html" "text/html")
    "/audio" (static-response "audio.html" "text/html")
    "/image" (static-response "index.html" "text/html")
    "/lottie" (static-response "lottie.html" "text/html")
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
        (= "/" uri) (static-response "index.html" "text/html")
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
        (circlet/server loaded-app port host)
    ))
