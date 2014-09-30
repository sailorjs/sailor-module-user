## -- Dependencies -----------------------------------------------------------------------

should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'
userHelper = require './helpers/userHelper'

## -- Test ------------------------------------------------------------------------------

describe "Relationship :: ", ->

  # we have user1 and user, need 3 more users
  before (done) ->
    userHelper.setCounter(2)
    userHelper.register(2, url.create, done)


  xit 'all users', (done) ->
    request
    .get(url.find).end (res) ->
      console.log res.body
      done()

  xit 'user1 start follow user2 and user3', (done) ->
    request
    .post "#{url.find}/1/following/2"
    .end (res) ->
      request
      .post "#{url.find}/1/following/3"
      .end (res) ->
        request
        .get "#{url.find}/1/following"
        .end (res) ->
          res.body[0].id.should.equal 2
          res.body[1].id.should.equal 3
          done()

