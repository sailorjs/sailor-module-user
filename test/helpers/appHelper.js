var fs        = require('fs-extra');
var wrench    = require('wrench');
var _         = require('lodash');
var exec      = require('child_process').exec;
var path      = require('path');
var sailsBin  = path.resolve('./node_modules/sails/bin/sails.js');
var spawn     = require('child_process').spawn;
var _ioClient = require('./sails.io')(require('socket.io-client'));
var Sails     = require('../../node_modules/sails/lib/app');
var sh        = require('execSync');
var prc;

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

module.exports.build = function( /* [appName], done */ ) {
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

module.exports.writeFile = function(file, txt, done) {
  fs.writeFile(file, txt, function(err) {
    if (err) return done(err);
    return done();
  });
};

module.exports.sh = function(command) {
  sh.run(command);
};

module.exports.clean = function(appName) {
  appName = appName ? appName : 'testApp';
  var dir = path.resolve('./../', appName);
  if (fs.existsSync(dir)) {
    wrench.rmdirSyncRecursive(dir);
  }
};

module.exports.start = function(done) {

  console.log("Running process in: " + process.cwd());

  // SPAWN

  prc = spawn('./../node_modules/sails/bin/sails.js', ['lift', ["--silly"]]);

  prc.stdout.setEncoding('utf8');
  prc.stdout.on('data', function(data) {
    console.log('stdout: ' + data);
  });

  prc.stderr.on('data', function(data) {
    console.log('stderr: ' + data);
  });

  prc.on('close', function(code) {
    console.log('child process exited with code ' + code);
  });

};

module.exports.stop = function() {

};

module.exports.liftWithTwoSockets = function(options, callback) {
  if (typeof options == 'function') {
    callback = options;
    options = null;
  }
  module.exports.lift(options, function(err, sails) {
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

module.exports.buildAndLiftWithTwoSockets = function(appName, options, callback) {
  if (typeof options == 'function') {
    callback = options;
    options = null;
  }
  module.exports.build(appName, function() {
    module.exports.liftWithTwoSockets(options, callback);
  });
};
