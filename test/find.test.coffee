###
Dependencies
###
should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'

describe "Find :: /GET user", ->

  describe '200 OK', ->

    it 'all users', (done) ->
      request.get(url.find).end (res) ->
        user_one = res.body[0]
        user_two = res.body[1]

        user_one.id.should.equal 1
        user_one.email.should.equal 'user1@sailor.com'

        user_two.id.should.equal 2
        user_two.email.should.equal 'user2@sailor.com'
        user_two.username.should.equal 'user2'

        res.status.should.equal 200

        done()

    it 'user by id that exists', (done) ->
      request
      .get url.find
      .query
        id: '1'
      .end (res) ->
        res.status.should.equal 200
        res.body.id.should.equal 1
        res.body.email.should.equal 'user1@sailor.com'
        done()

    it 'user by username that exists', (done) ->
      request
      .get url.find
      .query
        username: "user2"
      .end (res) ->
        res.status.should.equal 200
        res.body[0].id.should.equal 2
        res.body[0].email.should.equal 'user2@sailor.com'
        done()

    it 'user by email that exists', (done) ->
      request
      .get url.find
      .query
        email: "user1@sailor.com"
      .end (res) ->
        res.status.should.equal 200
        res.body[0].id.should.equal 1
        res.body[0].email.should.equal 'user1@sailor.com'
        done()

  describe '404 notFound', ->
    it 'user by id that does\'t exist', (done) ->
      request
      .get url.find
      .query
        id: '999'
      .end (res) ->
        res.status.should.equal 404
        done()

    it 'user by username that doesn\'t exist', (done) ->
      request.get url.find
      .query
        username: 'kikomola'
      .end (res) ->
        res.status.should.equal 404
        done()

    it 'user by email that doesn\'t exist', (done) ->
      request.get url.find
      .query
        email: 'trollme@github.com'
      .end (res) ->
        res.status.should.equal 404
        done()
