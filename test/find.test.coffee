###
Dependencies
###
should    = require("should")
request   = require("superagent")
url       = require("./helpers/urlHelper")

describe "Find ::", ->

  describe 'all', ->
    it 'should be 200 OK', (done) ->
      request.get(url.local.find).end (res) ->
        user_one = res.body[0]
        user_two = res.body[1]

        res.status.should.equal 200

        user_one.id.should.equal 1
        user_one.email.should.equal 'user1@sailor.com'

        user_two.id.should.equal 2
        user_two.email.should.equal 'user2@sailor.com'
        user_two.username.should.equal 'user2'

        done()

  describe 'by id', ->
    it 'should be 200 OK', (done) ->
      request.get(url.local.find+'/1').end (res) ->
        res.status.should.equal 200
        res.body.id.should.equal 1
        res.body.email.should.equal 'user1@sailor.com'
        done()

  describe 'by username', ->
    it 'should be 200 OK', (done) ->
      request
      .get(url.local.find)
      .query(username: "user2")
      .end (res) ->
        res.status.should.equal 200
        res.body[0].id.should.equal 2
        res.body[0].email.should.equal 'user2@sailor.com'
        done()

  describe 'by email', ->
    it 'should be 200 OK', (done) ->
      request
      .get(url.local.find)
      .query(email: "user1@sailor.com")
      .end (res) ->
        res.status.should.equal 200
        res.body[0].id.should.equal 1
        res.body[0].email.should.equal 'user1@sailor.com'
        done()
