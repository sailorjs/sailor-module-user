sort = require("sort-keys")

###
User.js

@description :: TODO: You might write a short summary of how this model works and what it represents here.
@docs        :: http://sailsjs.org/#!documentation/models
###

module.exports =

  # Enforce model schema in the case of schemaless databases
  schema: true
  attributes:
    username:
      type: "string"
      unique: true

    email:
      type: "email"
      unique: true
      required: true

    passports:
      collection: "Passport"
      via: "user"

    # Additional information
    # # TODO: http://jsonresume.org/
    # Avatar
    # Admin
    # Online
    # fullname Function

    avatar: type: 'string'


    toJSON: ->
      obj = @toObject()
      delete obj.passports
      sort obj
