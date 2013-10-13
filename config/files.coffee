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

    coffee:
      app: "background/js/**/*.coffee"
      generated: "background.coffee.js"

    css:
      app: "background/css/**/*.css"
      vendor: "vendor/background/css/**/*.css"
      concatenated: "<%= pkg.name %>_background.css"

    less:
      app: "background/css/**/*.less"
      vendor: "vendor/background/css/**/*.less"
      generatedApp: "background.less.css"
      generatedVendor: "background.vendor.less.css"

    pages:
      source: "background/background.*"
      generated: "background.html"

    template:
      underscore: [ "background/templates/**/*.underscore", "background/templates/**/*.us" ]
      generatedUnderscore: "background.underscore.js"
      generated: [
        "generated/<%= files.background.template.generatedUnderscore %>"
      ]
