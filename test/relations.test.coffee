## -- Dependencies -----------------------------------------------------------------------

should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'
userHelper = require './helpers/userHelper'

## -- Test ------------------------------------------------------------------------------

# we have user1 and user, need 3 more users
# before (done) ->
#   userHelper.setCounter(2)
#   userHelper.register(2, url.create, done)

# xit 'all users', (done) ->
#   request
#   .get(url.find).end (res) ->
#     console.log res.body
#     done()

describe "Relationship :: ", ->

  describe "add :: POST #{url.following}", ->

    describe '200 OK', ->

      it 'user1 starts follow user2', (done) ->
        request
        .post url.following
        .send
          id: '1'
          follower: '2'
        .end (res) ->
          res.status.should.equal 200
          res.body.following.should.eql 1
          done()

    describe '400 NotFound', ->

      it 'user1 starts follow user2 that doesnt exist', (done) ->
        request
        .post url.following
        .send
          id: '1'
          follower: '99'
        .end (res) ->
          res.status.should.equal 404
          done()

      it 'user1 that doesnt exists starts follow user2', (done) ->
        request
        .post url.following
        .send
          id: '99'
          follower: '1'
        .end (res) ->
          res.status.should.equal 404
          done()

      it 'both doesnt exist', (done) ->
        request
        .post url.following
        .send
          id: '99'
          follower: '98'
        .end (res) ->
          res.status.should.equal 404
          done()

  describe "get :: GET #{url.following} or #{url.follower}", ->
    describe '200 OK', ->
      it 'user2 is in the user1 following list', (done) ->
        request
        .get url.following
        .query
          id: '1'
        .end (res) ->
          res.status.should.equal 200
          res.body.count.should.eql 1
          res.body.following[0].id.should.eql 2
          done()

      it 'user1 is in the user2 followers list', (done) ->
        request
        .get url.follower
        .query
          id: '2'
        .end (res) ->
          res.status.should.equal 200
          res.body.count.should.eql 1
          res.body.followers[0].id.should.eql 1
          done()

    describe '400 NotFound', ->
      it 'user2 is in the user1 following list', (done) ->
        request
        .get url.following
        .query
          id: '99'
        .end (res) ->
          res.status.should.equal 404
          done()

  describe "status :: GET #{url.status}", ->
    describe '200 OK', ->
      it 'user1 status with user2', (done) ->
        request
        .get url.status
        .query
          id: '1'
          follower: '2'
          lang: 'es'
        .end (res) ->
          res.status.should.equal 200
          res.body.you.should.equal 'Siguiendo'
          res.body.follower.should.equal 'No te sigue'
          done()

  describe "remove :: DELETE #{url.following}", ->
    describe '200 OK', ->
      it 'user1 stops follow user2', (done) ->
        request
        .del url.following
        .send
          id: '1'
          follower: '2'
        .end (res) ->
          res.status.should.equal 200
          res.body.following.should.eql 0
          done()

      it 'user2 is not in the user1 following list', (done) ->
        request
        .get url.following
        .query
          id: '1'
        .end (res) ->
          res.status.should.equal 200
          res.body.count.should.eql 0
          res.body.following.length.should.eql 0
          done()

      it 'user1 is not in the user2 followers list', (done) ->
        request
        .get url.follower
        .query
          id: '2'
        .end (res) ->
          res.status.should.equal 200
          res.body.count.should.eql 0
          res.body.followers.length.should.eql 0
          done()
