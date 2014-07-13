var fs        = require('fs-extra');
var wrench    = require('wrench');
var _         = require('lodash');
var exec      = require('child_process').exec;
var path      = require('path');
var sailsBin  = path.resolve('./node_modules/sails/bin/sails.js');
var _ioClient = require('./sails.io')(require('socket.io-client'));
var Sails     = require('../../node_modules/sails/lib/app');
var sailsLift = require('../../node_modules/sails/bin/sails-lift');
var pkg       = require('../../package.json');

// Make existsSync not crash on older versions of Node
fs.existsSync = fs.existsSync || path.existsSync;

/**
 * Uses the Sails binary to create a namespaced test app
 * If no appName is given use 'testApp'
 *
 * It copies all the files in the fixtures folder into their
 * respective place in the test app so you don't need to worry
 * about setting up the fixtures.
 */

var _build = function( /* [appName], done */ ) {
  var args = Array.prototype.slice.call(arguments),
    done = args.pop(),
    appName = 'testApp';

  // Allow App Name to be optional
  if (args.length > 0) appName = args[0];

  // Cleanup old test fixtures
  if (fs.existsSync(appName)) {
    wrench.rmdirSyncRecursive(path.resolve('./', appName));
  }

  exec(sailsBin + ' new ' + appName, function(err) {
    if (err) return done(err);

    process.chdir(appName);
    return done();
  });
};

var _clean = function() {
  var dir = process.cwd();
  // appName = appName ? appName : 'testApp';
  // var dir = path.resolve('./../', appName);
  if (fs.existsSync(dir)) {
    wrench.rmdirSyncRecursive(dir);
  }
};


var _linkPlugin = function(callback){
  var origin = path.resolve(process.cwd(), '..');
  var dist = path.resolve(process.cwd(), 'node_modules', pkg.name);
  fs.symlink(origin, dist, callback);
};

var _lift = function(options, callback) {

  delete process.env.NODE_ENV;

  if (typeof options == 'function') {
    callback = options;
    options = null;
  }

  options = options || {};
  _.defaults(options, {
    port: 1342
  });

  Sails().lift(options, function(err, sails) {
    if (err) return callback(err);
    sails.kill = sails.lower;
    return callback(null, sails);
  });

};

/**
 * [_buildAndLift description]
 * @param  {[type]}   logLevel [description]
 * @param  {Function} done     [description]
 * @return {[type]}            [description]
 */
var _buildAndLift = function(logLevel, done){

  if (arguments.length === 1)
    logLevel = "silent";

  _build(function(){
    _linkPlugin(function(){
      _lift({
          verbose: false,
          log: {
            level: logLevel
          },
          // Lift method don't link rc file :-(
          plugins: [pkg.name]
        }, function(err, sails) {
          if (err) {
            throw new Error(err);
          }
          sailsprocess = sails;
          setTimeout(done, 100);
        });
    });
  });
};

var _liftWithTwoSockets = function(options, callback) {
  if (typeof options == 'function') {
    callback = options;
    options = null;
  }
  _lift(options, function(err, sails) {
    if (err) {
      return callback(err);
    }
    var socket1 = _ioClient.connect('http://localhost:1342', {
      'force new connection': true
    });
    socket1.on('connect', function() {
      var socket2 = _ioClient.connect('http://localhost:1342', {
        'force new connection': true
      });
      socket2.on('connect', function() {
        callback(null, sails, socket1, socket2);
      });
    });
  });
};

var _buildAndLiftWithTwoSockets = function(appName, options, callback) {
  if (typeof options == 'function') {
    callback = options;
    options = null;
  }
  _build(appName, function() {
    _liftWithTwoSockets(options, callback);
  });
};

// Exports
module.exports = {
  build                      : _build,
  clean                      : _clean,
  linkPlugin                 : _linkPlugin,
  lift                       : _lift,
  buildAndLift               : _buildAndLift,
  liftWithTwoSockets         : _liftWithTwoSockets,
  buildAndLiftWithTwoSockets : _buildAndLiftWithTwoSockets
};
