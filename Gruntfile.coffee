module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  grunt.initConfig

    # =============
    # SETUP
    # =============
    orig   : 'translation/*.tl'
    js     : 'config/translation.js'
    coffee : 'config/translation.coffee'

    # =============
    # TASKS
    # =============
    translate_compile:
      main:
        options:
          multipleObjects : true
          moduleExports   : true

        files: '<%= js %>': ['<%= orig %>']

    js2coffee:
      main:
        options:
          single_quotes: true

        src:  '<%= js %>'
        dest: '<%= coffee %>'

    clean: ['<%= js %>']

    watch:
      translations:
        files: ['<%= orig %>']
        tasks: ['translate_compile', 'js2coffee', 'clean']

  # =============
  # REGISTER
  # =============
  grunt.registerTask 'default', ['translate_compile', 'js2coffee', 'clean', 'watch']
  grunt.registerTask 'dev', ['translate_compile', 'watch']
