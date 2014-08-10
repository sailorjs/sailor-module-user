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

    describe '200 OK', ->

      it "register user without username", (done) ->
        request.post(url.create).send
          email: "user1@sailor.com"
          password: "password"
        .end (res) ->
          res.status.should.equal 200
          done()

      it "register user with email, username and password", (done) ->
        request.post(url.create).send(
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        ).end (res) ->
          res.status.should.equal 200
          done()

      it "register user and respond the new user", (done) ->
        request.post(url.create).send
          username: "user3"
          email: "user3@sailor.com"
          password: "password"
        .end (res) ->
          res.status.should.equal 200
          res.body.email.should.equal 'user3@sailor.com'
          res.body.username.should.equal 'user3'
          done()

      it "register that is already registered", ->
        request.post(url.create).send
          username: "user2"
          email: "user2@sailor.com"
          password: "password"
        .end (res) ->
          res.status.should.equal 400

    describe '400 BadRequest', ->

      it "register user without parameters", (done) ->
        request.post(url.create).send().end (res) ->
          res.status.should.equal 400
          done()

      it "register user without password", (done) ->
        request.post(url.create).send
          email: "user1@sailor.com"
        .end (res) ->
          res.status.should.equal 400
          done()

      it "register user without email", (done) ->
        request.post(url.create).send
          password: "password"
        .end (res) ->
          res.status.should.equal 400
          done()

  describe "Facebook Strategy", ->
    # TODO
  describe "Twitter Strategy", ->
    # TODO
  describe "Github Strategy", ->
    # TODO
  describe "Google Strategy", ->
    # TODO
