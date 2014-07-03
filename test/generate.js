/**
 * Generate Testing Scaffolding
 *
 * TOOD: Integrate it in suite tests
 * (and load plugins correctly)
 */


/**
 * Module Dependencies
 */
var appHelper = require('./helpers/appHelper');
var pkg       = require('../package.json');
var sailsrc   = require('multiline')(function() {
    /*
{
  "generators": {
    "modules": {}
  },
  "plugins": [
    "%s"
  ]
}
*/
  }),
sailsrc  = require('util').format(sailsrc, pkg.name);
var path = require('path');
var exec = require('child_process').exec;
var prc;

/**
 * Setup
 */
appHelper.build(function() {
  // TODO: Link provisional version of sails that support plugins
  console.log("Linked provisional version of sails...");
  appHelper.sh('cd .. && rm testApp/node_modules/sails');
  appHelper.sh('ln -s ../../node_modules/sails/ ../testApp/node_modules/sails');
  appHelper.sh('ln -s ../../../' + pkg.name + '/ ../testApp/node_modules/' + pkg.name);
  console.log("Writing .sailsrc for plugin...");
  appHelper.writeFile('../testApp/.sailsrc', sailsrc, function(){
    console.log("Running the server...");
    appHelper.start();
  });
});
