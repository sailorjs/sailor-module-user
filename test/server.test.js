/**
 * Dependencies
 */
var should     = require('should');
var request    = require('superagent');
var assert     = require('assert');
var url        = 'http://localhost:1337';

///////////////
/// TESTING ///
///////////////

describe('Server ::', function() {

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
