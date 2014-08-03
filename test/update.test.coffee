###
Dependencies
###
pkg       = require '../package.json'
url       = require './helpers/urlHelper'
should    = require 'should'
request   = require 'superagent'

## Testing
describe "Update :: /PUT user", ->
  describe "trying to updated a user that doesn't exist", ->
    it "should be 400 BadRequest", (done) ->
      request.put(url.local.update).send(
        username: "user21"
        password: "passsword"
      ).end (res) ->
        res.status.should.equal 400
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

