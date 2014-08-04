###
Dependencies
###
pkg       = require '../package.json'
url       = require './helpers/urlHelper'
fs        = require 'fs'
should    = require 'should'
request   = require 'superagent'
sailor    = require 'sailorjs'
scripts   = sailor.scripts

opts =
  log: level: "silent"
  plugins: [pkg.name]

MODULE = process.cwd()
LINK   = "#{process.cwd()}/testApp/node_modules/sailor-module-user"

## Setup
before (done) ->
  if (!fs.existsSync("#{MODULE}/testApp"))
    scripts.newBase ->
      scripts.link MODULE, LINK, ->
        scripts.writePluginFile pkg.name, ->
          scripts.lift opts, done
  else
    scripts.clean "#{MODULE}/.tmp/"
    scripts.clean "#{MODULE}/testApp/.tmp/"
    scripts.lift opts, done

# after (done) ->
  # scripts.clean done

## Testing
describe "Create :: /POST user", ->
  describe "Local Strategy ", ->
    describe "register user without parameters", ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send({}).end (res) ->
          res.status.should.equal 400
          done()

    describe "register user without password", ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send(email: "user1@sailor.com").end (res) ->
          res.status.should.equal 400
          done()

    describe "register user without email", ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send(password: "password").end (res) ->
          res.status.should.equal 400
          done()

    describe "register user without username", ->
      it "should be 200 OK", (done) ->
        request.post(url.create).send(
          email: "user1@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 200
          done()

    describe "register user with email, username and password", ->
      it "should be 200 OK", (done) ->
        request.post(url.create).send(
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 200
          done()

    describe "register user and respond the new user", ->
      it "should be 200 OK", (done) ->
        request.post(url.create).send(
          username: "user3"
          email: "user3@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 200
          res.body.email.should.equal 'user3@sailor.com'
          res.body.username.should.equal 'user3'
          done()

    describe "register that is already registered", ->
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
