module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      glob_to_multiple:
        expand: true
        flatten: true
        cwd: "public/scripts"
        src: "*.coffee"
        dest: "public/dest/scripts"
        ext: ".js"

    sass:
      dist:
        files:
          "public/dest/stylesheets/application.css" : "public/stylesheets/application.sass"
    watch:
      coffee:
        files: "public/scripts/*.coffee"
        tasks: "coffee"

      css:
        files: "public/stylesheets/**/*.sass"
        tasks: "sass"

      livereload:
        options:
          livereload: true
        files: "public/dest/**/*"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["coffee", "sass"]
