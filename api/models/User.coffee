## -- Dependencies -------------------------------------------------------------

sort = require 'sort-keys'

## -- Exports -------------------------------------------------------------
# Based on http://jsonresume.org/

module.exports =
  schema: true

  attributes:
    # essential
    username   : type: 'string', notNull: true
    email      : type: 'email', unique: true, required: true
    picture    : type: 'string'
    rol        : type: 'string', enum: ['user', 'admin'], defaultsTo: 'user'
    label      : type: 'string'
    online     : type: 'boolean', defaultsTo: false

    # complementary
    firstName  : type: 'string'
    lastName   : type: 'string'
    age        : type: 'string'
    birthDate  : type: 'date'
    phone      : type: 'string'
    website    : type: 'string'
    summary    : type: 'string'
    country    : type: 'string'

    website    : type: "string", url: true
    facebook   : type: "string", url: true
    twitter    : type: "string", url: true
    linkedin   : type: "string", url: true

    passports  : collection: 'Passport', via: 'user'
    following  : collection: 'User'
    followers  : collection: 'User'

    setOnline: (done) ->
      @online = true
      @save (err, user) ->
        done(err, user)

    setOffline: (done) ->
      @online = false
      @save (err, user) ->
        done(err, user)

    onLogin: (done) ->
      @setOnline(done)

    onLogout: (done) ->
      @setOffline(done)

    getFollowers: ->
      count: @getFollowersCount()
      followers: @followers

    getFollowing: ->
      count: @getFollowingCount()
      following: @following

    getFollowersCount: ->
      @followers.length

    getFollowingCount: ->
      @following.length

    addFollower: (user) ->
      @followers.push user
      @save

    addFollowing: (user) ->
      @following.push user
      @save

    # removeFollowing: (id) ->
    # removeFollower: (id) ->

    fullName:  ->
     "#{@firstName} #{@lastName}"

    toJSON: (done) ->
      obj = @toObject()
      obj.followers = @getFollowersCount()
      obj.following = @getFollowingCount()
      delete obj.passports
      sort obj
