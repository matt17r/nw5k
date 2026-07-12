# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "tom-select" # 2.6.2, bundled to a single ESM file in vendor/javascript
pin_all_from "app/javascript/controllers", under: "controllers"
