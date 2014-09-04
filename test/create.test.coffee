## -- Dependencies -----------------------------------------------------------------------

should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'

## -- Test ------------------------------------------------------------------------------

describe "Create :: /POST user", ->

  describe "Local Strategy ", ->

    describe '200 OK', ->

      it "register user without username and return the user", (done) ->
        request.post(url.create).send
          email: "user1@sailor.com"
          password: "password"
        .end (res) ->
          res.status.should.equal 200
          res.body.email.should.equal 'user1@sailor.com'
          res.body.online.should.equal true
          done()

      it "register user with email, username and password and return the user", (done) ->
        request.post(url.create).send
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        .end (res) ->
          res.status.should.equal 200
          res.body.email.should.equal 'user2@sailor.com'
          res.body.online.should.equal true
          done()

    describe '400 BadRequest', ->

      it "try to register a user without parameters", (done) ->
        request.post(url.create).send().end (res) ->
          res.status.should.equal 400
          done()

      it "try to register a user without password", (done) ->
        request.post(url.create).send
          email: "user1@sailor.com"
        .end (res) ->
          res.status.should.equal 400
          done()

      it "try to register a user without email", (done) ->
        request.post(url.create).send
          password: "password"
        .end (res) ->
          res.status.should.equal 400
          done()

      it "register that is already registered", ->
        request.post(url.create).send
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        .end (res) ->
          res.status.should.equal 400

  describe "Facebook Strategy", ->
    # TODO
  describe "Twitter Strategy", ->
    # TODO
  describe "Github Strategy", ->
    # TODO
  describe "Google Strategy", ->
    # TODO
