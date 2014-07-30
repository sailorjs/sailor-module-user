###
Dependencies
###
url       = require './helpers/urlHelper'
should    = require 'should'
request   = require 'superagent'

describe "Login ::", ->

  describe "without parameters", ->
    it "should be 400 BadRequest", (done) ->
      request.post(url.local.login).send({}).end (res) ->
        res.status.should.equal 400
        done()

  describe "bad identifier", ->
    it "should be 400 BadRequest", (done) ->
      request.post(url.local.login).send(
        identifier: "userrrrr@sailor.com"
        password: "password"
      ).end (res) ->
        res.status.should.equal 400
        res.body.model.should.eql("User")
        done()

  describe "bad password", ->
    it "should be 400 BadRequest", (done) ->
      request.post(url.local.login).send(
        identifier: "user2@sailor.com"
        password: "passsword"
      ).end (res) ->
        res.status.should.equal 400
        res.body.model.should.eql("User")
        done()

  describe "successful login with email", ->
    it "should be 200 OK", (done) ->
      request.post(url.local.login).send(
        identifier: "user2@sailor.com"
        password: "password"
      ).end (res) ->
        res.status.should.equal 200
        done()

  describe "successful login with username", ->
    it "should be 200 OK", (done) ->
      request.post(url.local.login).send(
        identifier: "user2"
        password: "password"
      ).end (res) ->
        res.status.should.equal 200
        done()
