###
Dependencies
###
url       = require './helpers/urlHelper'
should    = require 'should'
request   = require 'superagent'

describe "Login :: /GET user/login", ->

  describe '200 OK', ->

    it "username and password", (done) ->
      request
      .post url.login
      .send
        identifier: 'user2'
        password: 'password'
      .end (res) ->
        res.status.should.equal 200
        res.body.username.should.equal 'user2'
        done()

    it "email and password", (done) ->
      request
      .post url.login
      .send
        identifier: 'user2@sailor.com'
        password: 'password'
      .end (res) ->
        res.status.should.equal 200
        res.body.email.should.equal 'user2@sailor.com'
        done()

  describe '400 BadRequest', ->

    it "without parameters", (done) ->
      request
      .post url.login
      .send()
      .end (res) ->
        res.status.should.equal 400
        done()

    it "only password parameter", (done) ->
      request
      .post url.login
      .send
        password: 'password'
      .end (res) ->
        res.status.should.equal 400
        done()

    it "only identifier parameter", (done) ->
      request
      .post url.login
      .send
        identifier: 'user2'
      .end (res) ->
        res.status.should.equal 400
        done()

    it "email as wrong identifier and password", (done) ->
      request
      .post url.login
      .send
        email: 'fakemail@domain.com'
        password: 'password'
      .end (res) ->
        res.status.should.equal 400
        done()

    it "username as wrong identifier and password", (done) ->
      request
      .post url.login
      .send
        identifier: 'user9890890'
        password: 'password'
      .end (res) ->
        res.status.should.equal 400
        done()
