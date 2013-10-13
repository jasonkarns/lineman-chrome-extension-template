lineman = require(process.env["LINEMAN_MAIN"])

# completely ignore Lineman's built-in application config
config =
  pkg: lineman.grunt.file.readJSON("package.json")

  appTasks:
    common: [ "coffee", "less", "jshint", "jst", "concat", "copy", "pages" ]
    dev: [ "exec", "watch" ]
    dist: []

  loadNpmTasks: [
    "grunt-contrib-copy"
    "grunt-exec"
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

  jst:
    background:
      src: "<%= files.background.template.underscore %>"
      dest: "generated/<%= files.background.template.generatedUnderscore %>"

  less:
    background:
      files:
        "generated/<%= files.background.less.generatedApp %>": "<%= files.background.less.app %>"
        "generated/<%= files.background.less.generatedVendor %>": "<%= files.background.less.vendor %>"

  pages:
    background:
      src: "<%= files.background.pages.source %>"
      dest: "generated/<%= files.background.pages.generated %>"
      context:
        js: "<%= files.background.js.concatenated %>"
        css: "<%= files.background.css.concatenated %>"

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

module.exports = config
