## -- Dependencies -------------------------------------------------------------

sailor = require 'sailorjs'
sort   = sailor.util.sortKeys

## -- Exports -------------------------------------------------------------
# Inspired in http://jsonresume.org and https://represent.io

module.exports =
  schema: true

  attributes:
    # essential
    username   : type: 'string', notNull: true
    email      : type: 'email', unique: true, required: true
    picture    : type: 'string' #, url: true
    cover      : type: 'string' #, url: true
    rol        : type: 'string', enum: ['user', 'moderator', 'admin'], defaultsTo: 'user'
    label      : type: 'string'
    online     : type: 'boolean', defaultsTo: false

    # complementary
    firstName  : type: 'string'
    lastName   : type: 'string'
    age        : type: 'string'
    birthDate  : type: 'date'
    phone      : type: 'string'
    summary    : type: 'string'
    country    : type: 'string'

    website    : type: 'string', url: true
    facebook   : type: 'string', url: true
    twitter    : type: 'string', url: true
    linkedin   : type: 'string', url: true

    passports  : collection: 'Passport', via: 'user'
    following  : collection: 'User'
    follower   : collection: 'User'

    setOnline: (done) ->
      @online = true
      @save(done)

    setOffline: (done) ->
      @online = false
      @save(done)

    onLogin: (done) ->
      @setOnline(done)

    onLogout: (done) ->
      @setOffline(done)

    addFollower: (user, cb) ->
      @follower.add user
      @save(cb)

    addFollowing: (user, cb) ->
      @following.add user
      @save(cb)

    removeFollower: (id, cb) ->
      @follower.remove id
      @save(cb)

    removeFollowing: (id, cb) ->
      @following.remove id
      @save(cb)

    isFollowing: (id) ->
      _.find @following, (user) ->
        user.id = id

    fullName:  ->
      "#{@firstName} #{@lastName}"

    toJSON: ->
      obj = @toObject()
      delete obj.passports
      delete obj.follower
      obj.followers = @follower.length
      obj.following = @following.length
      sort obj
