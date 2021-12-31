(declare-project
  :name "bread"
  :description "Silly Bread"
  :author "Cendyne"
  :url "https://github.com/cendyne/bread"
  :repo "git+https://github.com/cendyne/bread"
  :dependencies [
    "https://github.com/cendyne/halo2.git"
    "https://github.com/swlkr/janet-html.git"
    ]
  )

(declare-native
  :name "_bread"
  :source @[
    "helper.c"
    ])

(declare-executable
  :name "bread"
  :entry "main.janet"
  :deps ["build/_bread.a"]
  )