(declare-project
  :name "bread"
  :description "Silly Bread"
  :author "Cendyne"
  :url "https://github.com/cendyne/bread"
  :repo "git+https://github.com/cendyne/bread"
  :dependencies [
    "https://github.com/janet-lang/circlet.git"
    ]
  )

(declare-executable
  :name "bread"
  :entry "src/main.janet"
  )