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
          translationVar  :'translations'
          asJson          : false
          moduleExports   : true
          coffee          : true

        files: '<%= js %>': ['<%= orig %>']

    watch:
      translations:
        files: ['<%= orig %>']
        tasks: ['translate_compile']

  # =============
  # REGISTER
  # =============
  grunt.registerTask 'default', ['translate_compile']
  grunt.registerTask 'dev', ['translate_compile', 'watch']
  # grunt.registerTask 'prod', 'translate_compile'
