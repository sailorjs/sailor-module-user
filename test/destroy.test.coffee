###
Dependencies
###
should    = require("should")
request   = require("superagent")
url       = require("./helpers/urlHelper")

describe "Destroy :: /PUT user", ->

  xdescribe "trying to remove user that doesn't exist", ->
    it "should be 404 NotFound", (done) ->
      request.del(url.destroy)
      .query(id: "123123")
      .end (res) ->
        res.status.should.equal 404
        done()

  describe "remove user by id", ->
    it "should be 200 OK", (done) ->
      request.del(url.destroy)
      .query(id: "1")
      .end (res) ->
        res.status.should.equal 200
        done()

  xdescribe "remove user by username", ->
    it "should be 200 OK", (done) ->
      request.del(url.destroy)
      .query(username: "user2")
      .end (res) ->
        res.status.should.equal 200
        done()

  xdescribe "remove user by email", ->
    it "should be 200 OK", (done) ->
      request.del(url.destroy)
      .query(email: "user1@sailor.com")
      .end (res) ->
        res.status.should.equal 200
        done()
