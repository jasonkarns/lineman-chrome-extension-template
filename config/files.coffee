# completely ignore Lineman's built-in files config

module.exports =
  manifest:
    source: "manifest.json"
    generated: "manifest.json"

  background:
    js:
      app: "background/js/**/*.js"
      vendor: "vendor/background/js/**/*.js"
      concatenated: "<%= pkg.name %>_background.js"

    css:
      app: "background/css/**/*.css"
      vendor: "vendor/background/css/**/*.css"
      concatenated: "<%= pkg.name %>_background.css"
