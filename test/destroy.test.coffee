###
Dependencies
###
should    = require("should")
request   = require("superagent")
url       = require("./helpers/urlHelper")

describe "Destroy :: /DEL user", ->

  describe '200 OK', ->

    it 'user by id that exists', (done) ->
      request.del(url.destroy)
      .query(id: '1')
      .end (res) ->
        res.status.should.equal 200
        res.body.id.should.equal 1
        res.body.email.should.equal 'user1@sailor.com'
        done()

    it 'user by username that exists', (done) ->
      request
      .del(url.destroy)
      .query(username: "user2")
      .end (res) ->
        res.status.should.equal 200
        res.body.id.should.equal 2
        res.body.email.should.equal 'user2@sailor.com'
        done()

    it 'user by email that exists', (done) ->
      request
      .del(url.destroy)
      .query(email: "user3@sailor.com")
      .end (res) ->
        res.status.should.equal 200
        res.body.id.should.equal 3
        res.body.email.should.equal 'user3@sailor.com'
        done()


  describe '404 notFound', ->

    it 'user by id that does\'t exist', (done) ->
      request.del(url.destroy)
      .query(id: '999')
      .end (res) ->
        res.status.should.equal 404
        done()

    it 'user by username that doesn\'t exist', (done) ->
      request.del(url.destroy)
      .query(username: 'kikomola')
      .end (res) ->
        res.status.should.equal 404
        done()

    it 'user by email that doesn\'t exist', (done) ->
      request.del(url.destroy)
      .query(email: 'trollme@github.com')
      .end (res) ->
        res.status.should.equal 404
        done()
