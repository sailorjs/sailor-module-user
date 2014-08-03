###
Dependencies
###
should    = require("should")
request   = require("superagent")
url       = require("./helpers/urlHelper")

describe "Destroy :: /PUT user", ->

  describe "trying to remove user that doesn't exist", ->
    it "should be 404 NotFound", (done) ->
      request.del(url.destroy)
      .query(id: "-1")
      .end (res) ->
        res.status.should.equal 404
        done()

  describe "remove user that exists", ->
    it "should be 200 OK", (done) ->
      request.del(url.destroy)
      .query(id: "1")
      .end (res) ->
        res.status.should.equal 200
        done()
