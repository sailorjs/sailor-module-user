/**
 * Dependencies
 */
var should     = require('should');
var request    = require('superagent');
var assert     = require('assert');
var appHelper  = require('./helpers/appHelper');
var pkg        = require('../package.json');
var url        = 'http://localhost:1342';

describe('Server ::', function() {

/////////////
/// SETUP ///
/////////////

before(function(done){
  appHelper.build(function() {
    // Linked provisional version of sails with support for plugins
    appHelper.sh('cd .. && rm testApp/node_modules/sails');
    appHelper.sh('ln -s ../../node_modules/sails/ ../testApp/node_modules/sails');
    appHelper.sh('ln -s ../../../' + pkg.name + '/ ../testApp/node_modules/' + pkg.name);
      appHelper.lift({
        verbose: false,
        log: {level: 'silent'},
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

after(function(){
  appHelper.clean();
});

///////////////
/// TESTING ///
///////////////

  describe('Server running', function() {
    it('should be 200 OK', function(done) {
      request.get(url)
        .end(function(res) {
          res.status.should.equal(200);
          done();
        });
    });
  });
});
