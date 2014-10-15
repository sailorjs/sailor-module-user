###
Dependencies
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
  pk    = actionUtil.requirePk(req)
  query = Model.findOne(pk)
  query = actionUtil.populateEach(query, req)

  query.exec (err, record) ->
    return res.serverError(err)  if err

    unless record
      err = msg: translate.get('User.NotFound')
      return res.notFound(sailor.errorify.serialize(err))

    # destroy passports objects
    _.forEach record.passports, (passport) ->

      Passport.destroy(passport.id).exec (err)->
      return res.negotiate(err)  if err

      Model.destroy(pk).exec (err) ->
        return res.negotiate(err)  if err

        if sails.hooks.pubsub
          Model.publishDestroy record.id, not sails.config.blueprints.mirror and req,
            previous: record

          if req.isSocket
            Model.unsubscribe req, record
            Model.retire record

        res.ok record
