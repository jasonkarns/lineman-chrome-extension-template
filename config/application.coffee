lineman = require(process.env["LINEMAN_MAIN"])

# completely ignore Lineman's built-in application config
config =
  pkg: lineman.grunt.file.readJSON("package.json")

  appTasks:
    common: [ "copy" ]
    dev: []
    dist: []

  loadNpmTasks: [
    "grunt-contrib-copy"
  ]

  clean:
    dev:
      src: "generated"
    dist:
      src: "dist"

  copy:
    manifest:
      src: "<%= files.manifest.source %>"
      dest: "generated/<%= files.manifest.generated %>"
      options:
        processContent: (content, srcpath) ->
          lineman.grunt.template.process content,
            data: config

module.exports = config
