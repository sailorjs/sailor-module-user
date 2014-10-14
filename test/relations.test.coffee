## -- Dependencies -----------------------------------------------------------------------

should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'
userHelper = require './helpers/userHelper'

## -- Test ------------------------------------------------------------------------------

describe "Relationship :: ", ->

  describe "add :: POST /user/following", ->

    describe '200 OK', ->

      it 'user1 starts follow user2', (done) ->
        request
        .post url.find + '/1/following'
        .send
          follower: '2'
        .end (res) ->
          res.status.should.equal 200
          res.body.following.should.eql 1
          done()

    describe '400 NotFound', ->

      it 'user1 starts follow user2 that doesnt exist', (done) ->
        request
        .post url.find + '/1/following'
        .send
          follower: '99'
        .end (res) ->
          res.status.should.equal 404
          done()

      it 'user1 that doesnt exists starts follow user2', (done) ->
        request
        .post url.find + '/1/following'
        .send
          follower: '98'
        .end (res) ->
          res.status.should.equal 404
          done()

      it 'both doesnt exist', (done) ->
        request
        .post url.find + '/99/following'
        .send
          follower: '98'
        .end (res) ->
          res.status.should.equal 404
          done()

  describe "GET :: /user/following or /user/follower", ->
    describe '200 OK', ->
      it 'user2 is in the user1 following list', (done) ->
        request
        .get url.find + '/1/following'
        .end (res) ->
          res.status.should.equal 200
          res.body[0].id.should.eql 2
          done()

      it 'user1 is in the user2 followers list', (done) ->
        request
        .get url.find + '/2/follower'
        .end (res) ->
          res.status.should.equal 200
          res.body[0].id.should.eql 1
          done()

    describe '400 NotFound', ->
      it 'user2 is in the user1 following list', (done) ->
        request
        .get url.find + '/99/following'
        .end (res) ->
          res.status.should.equal 404
          done()

  describe "status :: GET user/following/status", ->
    describe '200 OK', ->
      it 'user1 status with user2', (done) ->
        request
        .get url.find + '/1/following/status'
        .query
          follower: '2'
          lang: 'es'
        .end (res) ->
          res.status.should.equal 200
          res.body.you.should.equal 'Siguiendo'
          res.body.follower.should.equal 'No te sigue'
          done()

  describe "destroy :: DELETE user/:id/following", ->
    describe '200 OK', ->
      it 'user1 stops follow user2', (done) ->
        request
        .del url.find + '/1/following'
        .send
          follower: '2'
        .end (res) ->
          res.status.should.equal 200
          res.body.following.should.eql 0
          done()

      it 'user2 is not in the user1 following list', (done) ->
        request
        .get url.find + '/1/following'
        .end (res) ->
          res.status.should.equal 204
          request
          .get url.find + '/1'
          .end (res) ->
            res.body.followers.should.eql 0
            done()

      it 'user1 is not in the user2 followers list', (done) ->
        request
        .get url.find + '/2/follower'
        .end (res) ->
          res.status.should.equal 204
          request
          .get url.find + '/2'
          .end (res) ->
            res.body.following.should.eql 0
            done()
