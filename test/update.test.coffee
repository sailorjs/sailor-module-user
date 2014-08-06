###
Dependencies
###
should    = require("should")
request   = require("superagent")
url       = require("./helpers/urlHelper")

describe "Update :: /PUT user", ->

  describe '200 OK', ->

    it 'user by id that exists', (done) ->
      request.put("#{url.update}/3")
      .send
        label: 'beatbox'
      .end (res) ->
        res.status.should.equal 200
        res.body.label.should.equal 'beatbox'
        done()

    it 'user by id that exists but the key doesn\'t exist', (done) ->
      request.put("#{url.update}/3")
      .send
        randomKey: 'hello world'
      .end (res) ->
        res.status.should.equal 200
        done()

  describe '404 NotFound', ->

    it 'user by id doesn\'t exist', (done) ->
      request.put("#{url.update}/999")
      .end (res) ->
        res.status.should.equal 404
        done()
