var should  = require('should'),
    request = require('superagent'),
    asert   = require('assert');

///////////////
/// TESTING ///
///////////////

var url = 'http://localhost:1337';

describe('Server running', function() {
  it('Should be 200 OK', function(done) {
    request.get(url)
      .end(function(res) {
        res.status.should.equal(200);
        done();
      });
  });
});


describe('Local Strategy', function() {

  describe('Register', function() {

    describe('Register user without parameters', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({})
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Register user without password', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            email: "user1@sailor.com"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Register user without email', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Register user without username', function() {
      it('Should be 200 OK', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            email: "user1@sailor.com",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(200);
          });
      });
    });

    describe('Register user with email, username and password', function() {
      it('Should be 200 OK', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            username: "user2",
            email: "user2@sailor.com",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(200);
          });
      });
    });

    describe('Register that is already registered', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
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

  describe('Login', function() {

    describe('Login user without parameters', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({})
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Login user with username without errors', function() {
      it('Should be 200 OK', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            identifier: "user1",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(200);
          });
      });
    });

    describe('Login user with email without errors', function() {
      it('Should be 200 OK', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            identifier: "user1@sailor.com",
            password: "password"
          })
          .end(function(res) {
            res.status.should.equal(200);
          });
      });
    });

    describe('Login user with mail and wrong password', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            identifier: "user1@sailor.com",
            password: "pwd"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Login user with username and wrong password', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            identifier: "user1",
            password: "pwd"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Login user with wrong username', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            identifier: "user1123",
            password: "pwd"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });

    describe('Login user with wrong email', function() {
      it('Should be 400 BadRequest', function() {
        request
          .post(url + '/auth/local/register')
          .send({
            identifier: "user1123@sailor.com",
            password: "pwd"
          })
          .end(function(res) {
            res.status.should.equal(400);
          });
      });
    });
  });
});
