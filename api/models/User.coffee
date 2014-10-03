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

    addFollower: (user, cb) ->
      @followers.add user
      @save(cb)

    addFollowing: (user, cb) ->
      @following.add user
      @save(cb)

    removeFollower: (user, cb) ->
      @followers.remove user
      @save(cb)

    removeFollowing: (id, cb) ->
      @following.remove id
      @save(cb)

    isFollowing: (id) ->
      index = _.findIndex @following, (user) ->
        user.id = id

      if index is -1 then false else true

    fullName:  ->
     "#{@firstName} #{@lastName}"

    toJSON: (done) ->
      obj = @toObject()
      obj.followers = @getFollowersCount()
      obj.following = @getFollowingCount()
      delete obj.passports
      sort obj
