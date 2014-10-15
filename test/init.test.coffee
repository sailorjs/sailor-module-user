## -- Dependencies -----------------------------------------------------------------------

pkg          = require '../package.json'
sailor       = require 'sailorjs'
scripts      = sailor.scripts

## -- Setup ------------------------------------------------------------------------------

SCOPE =
  PATH : process.cwd()
  NAME : 'testApp'
  TMP  : '.tmp'

sailsOptions =
  log: level: 'silent'

before (done) ->
  unless (scripts.exist(SCOPE.NAME))
    scripts.newBase ->
      scripts.linkModule pkg.name
      scripts.lift "#{SCOPE.PATH}/#{SCOPE.NAME}", sailsOptions, done
  else
    scripts.clean "#{SCOPE.PATH}/#{SCOPE.NAME}/#{SCOPE.TMP}"
    scripts.lift "#{SCOPE.PATH}/#{SCOPE.NAME}", sailsOptions, done
