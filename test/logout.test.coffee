###
Dependencies
###
should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'

describe "Logout :: /GET user/logout", ->

  describe '200 OK', ->
    it 'user that is logged', (done) ->
      request
      .get url.logout
      .end (res) ->
        res.status.should.equal 200
        done()
