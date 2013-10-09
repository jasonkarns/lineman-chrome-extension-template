# completely ignore Lineman's built-in application config

module.exports =
  appTasks:
    common: []
    dev: []
    dist: []

  loadNpmTasks: [
  ]

  clean:
    dev:
      src: "generated"
    dist:
      src: "dist"
