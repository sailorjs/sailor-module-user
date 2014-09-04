## -- Dependencies -----------------------------------------------------------------------

pkg       = require '../package.json'
fs        = require 'fs'
scripts   = require 'sailor-scripts'

## -- Setup ------------------------------------------------------------------------------

opts =
  log: level: "silent"
  plugins: [pkg.name]

SCOPE =
  MODULE: process.cwd()
  TEST  : "#{process.cwd()}/testApp"
  LINK  : "#{process.cwd()}/testApp/node_modules/#{pkg.name}"

before (done) ->
  if (!fs.existsSync(SCOPE.TEST))
    scripts.newBase ->
      scripts.link SCOPE.MODULE, SCOPE.LINK, ->
        scripts.writePluginFile pkg.name, ->
          scripts.lift SCOPE.TEST, opts, done
  else
    scripts.clean "#{SCOPE.TEST}/.tmp/"
    scripts.lift SCOPE.TEST, opts, done
