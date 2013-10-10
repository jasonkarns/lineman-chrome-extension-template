lineman = require(process.env["LINEMAN_MAIN"])

# completely ignore Lineman's built-in application config
config =
  pkg: lineman.grunt.file.readJSON("package.json")

  appTasks:
    common: [ "concat", "copy", "pages" ]
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

  concat:
    backgroundCss:
      src: [ "<%= files.background.css.vendor %>", "<%= files.background.css.app %>" ]
      dest: "generated/<%= files.background.css.concatenated %>"

    backgroundJs:
      src: [ "<%= files.background.js.vendor %>", "<%= files.background.js.app %>" ]
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

    concatBackgroundCss:
      files: [ "<%= files.background.css.vendor %>", "<%= files.background.css.app %>" ]
      tasks: [ "concat:backgroundCss", "exec" ]

    concatBackgroundJs:
      files: [ "<%= files.background.js.vendor %>", "<%= files.background.js.app %>" ]
      tasks: [ "concat:backgroundJs", "exec" ]

    pagesBackground:
      files: "<%= files.background.pages.source %>"
      tasks: [ "pages:background", "exec" ]

module.exports = config
