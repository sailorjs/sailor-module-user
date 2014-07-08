/**
 * Dependencies
 */
var should     = require('should');
var request    = require('superagent');
var assert     = require('assert');
var appHelper  = require('./helpers/appHelper');
var url        = 'http://localhost:1342';
var url_local  =  url + '/auth/local/register';

describe('Create ::', function() {

/////////////
/// SETUP ///
/////////////

  before(function(done) {
    appHelper.buildAndLift(done);
  });

///////////////
/// TESTING ///
///////////////

  describe('Local Strategy', function() {

    describe('Register user without parameters', function() {
      it('should be 400 BadRequest', function(done) {
        request
          .post(url_local)
          .send({})
          .end(function(res) {
            res.status.should.equal(400);
            done();
          });
      });
    });

    describe('Register user without password', function() {
      it('should be 400 BadRequest', function(done) {
        request
          .post(url_local)
          .send({
            email: "user1@sailor.com"
          })
          .end(function(res) {
            res.status.should.equal(400);
            done();
          });
      });
    });

    describe('Register user without email', function() {
      it('should be 400 BadRequest', function(done) {
        request
          .post(url_local)
          .send({
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(400);
            done();
          });
      });
    });


    describe('Register user without username', function() {
      it('should be 200 OK', function(done) {
        request
          .post(url_local)
          .send({
            email: "user1@sailor.com",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(200);
            done();
          });
      });
    });

    describe('Register user with email, username and password', function() {
      it('should be 200 OK', function(done) {
        request
          .post(url_local)
          .send({
            username: "user2",
            email: "user2@sailor.com",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(200);
            done();
          });
      });
    });

    describe('Register that is already registered', function() {
      it('should be 400 BadRequest', function() {
        request
          .post(url_local)
          .send({
            username: "user2",
            email: "user2@sailor.com",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

  });

  describe('Facebook Strategy', function() {
    // TODO
  });

  describe('Twitter Strategy', function() {
    // TODO
  });

  describe('Github Strategy', function() {
    // TODO
  });

  describe('Google Strategy', function() {
    // TODO
  });

});
