###
Module dependencies
###
sailor     = require 'sailorjs'
actionUtil = sailor.actionUtil
translate  = sailor.translate
validator  = sailor.validator
errorify   = sailor.errorify

###
Destroy Blueprint
Destroy the user and the Model associated with the User
###
module.exports = (req, res) ->

  Model = actionUtil.parseModel(req)
  pk = actionUtil.requirePk(req)
  query = Model.findOne(pk).populateAll()

  query.exec (err, matchingRecords) ->

    return res.serverError(err)  if err

    unless matchingRecords
      name = sailor.capitalize(Model.identity)
      err = msg: translate.get("#{name}.NotFound")
      return res.notFound(sailor.errorify.serialize(err))

    # destroy passports objects
    _.forEach matchingRecords.passports, (passport) ->
      Passport.destroy(passport.id).exec (err)->

    return res.negotiate(err)  if err

    Model.destroy(pk).exec (err) ->

      return res.negotiate(err)  if err

      if sails.hooks.pubsub
        Model.publishDestroy matchingRecords.id, not sails.config.blueprints.mirror and req,
          previous: matchingRecords

        if req.isSocket
          Model.unsubscribe req, matchingRecords
          Model.retire matchingRecords

      res.ok matchingRecords
