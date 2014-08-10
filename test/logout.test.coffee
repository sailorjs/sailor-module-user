###
Dependencies
###
url       = require './helpers/urlHelper'
should    = require 'should'
request   = require 'superagent'

describe "Logout ::", ->

  describe '200 OK', ->
    it 'user that is logged', (done) ->
      request
      .get url.logout
      .end (res) ->
        res.status.should.equal 200
        done()
