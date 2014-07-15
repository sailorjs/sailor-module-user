###
Dependencies
###
should    = require("should")
request   = require("superagent")
assert    = require("assert")
app       = require("./helpers/appHelper")
url       = require("./helpers/urlHelper")

describe "Find ::", ->

  ## Setup
  before (done) -> app.buildAndLift done

  ## Testing
  describe "findOne", ->

    describe 'without parameters', ->
      it "should be 400 BadRequest", (done) ->
        request.post(url.create).send({}).end (res) ->
          res.status.should.equal 200
          done()
      done()

    describe "username doesn't exist", ->
      done()

    describe "email doesn't exist", ->
      done()

    describe "username exist", ->
      done()

    describe "email exist", ->
      done()
