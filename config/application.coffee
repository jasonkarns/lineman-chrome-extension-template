lineman = require(process.env["LINEMAN_MAIN"])
manifestSchema = require('chrome-extension-manifest-schema')

# completely ignore Lineman's built-in application config
config =
  pkg: lineman.grunt.file.readJSON("package.json")

  appTasks:
    common: [ "coffee", "less", "jshint", "handlebars", "jst", "concat", "copy:manifest", "minjson:manifest", "tv4:manifest", "images", "webfonts", "pages" ]
    dev: [ "exec", "watch" ]
    dist: []

  loadNpmTasks: [
    "grunt-contrib-copy"
    "grunt-exec"
    "grunt-minjson"
    "grunt-tv4"
  ]

  clean:
    dev:
      src: "generated"

    dist:
      src: "dist"

  coffee:
    background:
      src: "<%= files.background.coffee.app %>"
      dest: "generated/<%= files.background.coffee.generated %>"

  concat:
    backgroundCss:
      src: [
        "generated/<%= files.background.less.generatedVendor %>"
        "<%= files.background.css.vendor %>"
        "generated/<%= files.background.less.generatedApp %>"
        "<%= files.background.css.app %>"
      ]
      dest: "generated/<%= files.background.css.concatenated %>"

    backgroundJs:
      src: [
        "<%= files.background.js.vendor %>"
        "<%= files.background.template.generated %>"
        "generated/<%= files.background.coffee.generated %>"
        "<%= files.background.js.app %>"
      ]
      dest: "generated/<%= files.background.js.concatenated %>"

  copy:
    manifest:
      src: "<%= files.manifest.source %>"
      dest: "generated/<%= files.manifest.generated %>"
      options:
        processContent: (content, srcpath) ->
          lineman.grunt.template.process content,
            data: config

  exec:
    # Install 'Extensions Reloader': let's Lineman trigger a reload of unpacked extensions
    # https://chrome.google.com/webstore/detail/extensions-reloader/fimgfedafeadlieiabdeeaodndnlbhid
    reloadExtension:
      cmd: "open -g -a 'Google Chrome' http://reload.extensions"

  # requires handlebars-runtime at runtime
  handlebars:
    options:
      processName: (filename) ->
        filename
          .replace(/^(?:.*?\/){2}/, '') # kill top two directories (extension page template dir)
          .replace(/\.[^.]*$/, '') # kill file extension
    background:
      src: "<%= files.background.template.handlebars %>"
      dest: "generated/<%= files.background.template.generatedHandlebars %>"

  images:
    background:
      files: [
        { expand: true, cwd: "vendor/background/", src: "img/**/*.*", dest: "generated/" }
        { expand: true, cwd: "background/",        src: "img/**/*.*", dest: "generated/" }
      ]

  jshint:
    options:
      # enforcing options
      curly: true
      eqeqeq: true
      latedef: true
      newcap: true
      noarg: true
      # relaxing options
      boss: true
      eqnull: true
      sub: true
      # globals
      browser: true

    background:
      src: "<%= files.background.js.app %>"

  # requires underscore or lodash at runtime
  jst:
    options:
      processName: (filename) ->
        filename
          .replace(/^(?:.*?\/){2}/, '') # kill top two directories (extension page template dir)
          .replace(/\.[^.]*$/, '') # kill file extension

    background:
      src: "<%= files.background.template.underscore %>"
      dest: "generated/<%= files.background.template.generatedUnderscore %>"

  less:
    background:
      files:
        "generated/<%= files.background.less.generatedApp %>": "<%= files.background.less.app %>"
        "generated/<%= files.background.less.generatedVendor %>": "<%= files.background.less.vendor %>"

  minjson:
    manifest:
      src:  "generated/<%= files.manifest.generated %>"
      dest: "generated/<%= files.manifest.generated %>"

  pages:
    background:
      src: "<%= files.background.pages.source %>"
      dest: "generated/<%= files.background.pages.generated %>"
      context:
        js: "<%= files.background.js.concatenated %>"
        css: "<%= files.background.css.concatenated %>"

  tv4:
    manifest:
      src: "generated/<%= files.manifest.generated %>"
      options:
        multi: true
        root: manifestSchema

  webfonts:
    background:
      files: [
        { expand: true, cwd: "vendor/background/", src: "webfonts/**/*.*", dest: "generated/" }
        { expand: true, cwd: "background/",        src: "webfonts/**/*.*", dest: "generated/" }
      ]

  watch:
    manifest:
      files: "<%= copy.manifest.src %>"
      tasks: [ "copy:manifest", "exec" ]

    coffeeBackground:
      files: "<%= coffee.background.src %>"
      tasks: [ "coffee:background", "concat:backgroundJs", "exec" ]

    concatBackgroundCss:
      files: [ "generated/<%= files.background.less.generatedVendor %>", "<%= files.background.css.vendor %>", "generated/<%= files.background.less.generatedApp %>", "<%= files.background.css.app %>" ]
      tasks: [ "concat:backgroundCss", "exec" ]

    concatBackgroundJs:
      files: [ "<%= files.background.js.vendor %>", "<%= files.background.template.generated %>", "generated/<%= files.background.coffee.generated %>", "<%= files.background.js.app %>" ]
      tasks: [ "concat:backgroundJs", "exec" ]

    handlebarsBackground:
      files: "<%= files.background.template.handlebars %>"
      tasks: [ "handlebars:background", "concat:backgroundJs", "exec" ]

    imagesBackground:
      files: [ "vendor/background/img/**/*.*", "background/img/**/*.*" ]
      tasks: [ "images:background", "exec" ]

    jshintBackground:
      files: "<%= files.background.js.app %>"
      tasks: "jshint:background"

    lessBackground:
      files: [ "<%= files.background.less.app %>", "<%= files.background.less.vendor %>" ]
      tasks: [ "less:background", "concat:backgroundCss", "exec" ]

    pagesBackground:
      files: "<%= files.background.pages.source %>"
      tasks: [ "pages:background", "exec" ]

    underscoreBackground:
      files: "<%= files.background.template.underscore %>"
      tasks: [ "jst:background", "concat:backgroundJs", "exec" ]

    webfontsBackground:
      files: [ "vendor/background/webfonts/**/*.*" ]
      tasks: [ "webfonts:background", "exec" ]

module.exports = config
