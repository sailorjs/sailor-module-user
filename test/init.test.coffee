## -- Dependencies -----------------------------------------------------------------------

fs        = require 'fs'
pkg       = require '../package.json'
scripts   = require 'sailor-scripts'

## -- Setup ------------------------------------------------------------------------------

opts =
  log: level: "silent"

SCOPE =
  MODULE       : process.cwd()
  TEST         : "#{process.cwd()}/testApp"
  LINK         : "#{process.cwd()}/testApp/node_modules/#{pkg.name}"
  DEPENDENCIES : ['sailor-translate', 'sailor-validator', 'sailor-errorify']

before (done) ->
  if (!fs.existsSync(SCOPE.TEST))
    scripts.newBase ->
      scripts.linkDependency dependency for dependency in SCOPE.DEPENDENCIES
      scripts.link SCOPE.MODULE, SCOPE.LINK
      scripts.writeModuleFile pkg.name
      scripts.lift SCOPE.TEST, opts, done
  else
    scripts.clean "#{SCOPE.TEST}/.tmp/"
    scripts.lift SCOPE.TEST, opts, done
