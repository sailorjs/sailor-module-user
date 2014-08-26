sort = require 'sort-keys'

###
User.js
Based on http://jsonresume.org/

@description :: TODO: You might write a short summary of how this model works and what it represents here.
@docs        :: http://sailsjs.org/#!documentation/models
###

module.exports =

  # Enforce model schema in the case of schemaless databases
  # https://github.com/balderdashy/waterline-docs/blob/master/models.md
  schema: true

  attributes:
    username:
      type: "string"
      notNull: true

    email:
      type: "email"
      unique: true
      required: true

    passports:
      collection: "Passport"
      via: "user"

    label:
      type: "string"

    picture:
      type: "string"

    phone:
      type: "string"

    website:
      type: "string"

    summary:
      type: "string"

    admin:
      type: "boolean"
      defaultsTo: false

    online:
      type: "boolean"
      defaultsTo: false

    toJSON: (done) ->
      obj = @toObject()
      delete obj.passports
      sort obj

    setOnline: (done) ->
      @online = true
      @save (err, user) ->
        done(err, user)

    setOffline: (done) ->
      @online = false
      @save (err, user) ->
        done(err, user)
