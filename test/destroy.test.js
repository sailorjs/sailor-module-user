/**
 * Dependencies
 */
var should    = require('should');
var request   = require('superagent');
var assert    = require('assert');
var appHelper = require('./helpers/appHelper');
var url       = 'http://localhost:1342';

describe('Remove ::', function() {

/////////////
/// SETUP ///
/////////////

  before(function(done) {
    appHelper.buildAndLift(done);
  });

///////////////
/// TESTING ///
///////////////

  describe('Trying to remove user that don\'t exist', function() {
    it('should be 400 BadRequest', function(done) {
      request
        .del(url + '/user/user1')
        .end(function(res) {
          res.status.should.equal(400);
          done();
        });
    });
  });

  describe('Remove user that exist', function() {
    it('should be 200 OK', function(done) {
      // First register the user with local strategy
      request.post(url + '/auth/local/register')
        .send({
          email: "user2@sailor.com",
          username: "user2",
          password: "password"
        }).end(function() {
          request.del(url + '/user/user2')
            .end(function(res) {
              res.status.should.equal(200);
              done();
            });
        });

    });
  });
});
