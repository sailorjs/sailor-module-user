###
Dependencies
###
should    = require("should")
request   = require("superagent")
assert    = require("assert")
app       = require("./helpers/appHelper")
url       = require("./helpers/urlHelper")

describe "Create ::", ->

  ## Setup
  before (done) -> app.buildAndLift done

  ## Testing
  describe "Local Strategy", ->

    describe "Register user without parameters", ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send({}).end (res) ->
          res.status.should.equal 400
          done()

    describe "Register user without password", ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send(email: "user1@sailor.com").end (res) ->
          res.status.should.equal 400
          done()

    describe "Register user without email", ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send(password: "password").end (res) ->
          res.status.should.equal 400
          done()

    describe "Register user without username", ->
      it "should be 200 OK", (done) ->
        request.post(url.create).send(
          email: "user1@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 200
          done()

    describe "Register user with email, username and password", ->
      it "should be 200 OK", (done) ->
        request.post(url.create).send(
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 200
          done()

    describe "Register that is already registered", ->
      it "should be 400 BadRequest", ->
        request.post(url.create).send(
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 400

  # TODO
  describe "Facebook Strategy", ->

  # TODO
  describe "Twitter Strategy", ->

  # TODO
  describe "Github Strategy", ->

  # TODO
  describe "Google Strategy", ->
