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

  user          = {}
  user.id       = req.param('id') if req.param('id')
  user.username = req.param('username') if req.param('username')
  user.email    = req.param('email') if req.param('email')

  query = Model.findOne(user)
  query = actionUtil.populateEach(query, req)

  query.exec (err, matchingRecords) ->

    return res.serverError(err)  if err

    unless matchingRecords
      name = sailor.capitalize(Model.identity)
      err = msg: translate.get("#{name}.NotFound")
      return res.notFound(sailor.errorify.serialize(err))

    Model.destroy(matchingRecords.id).exec (err) ->

      return res.negotiate(err)  if err

      # if sails.hooks.pubsub
      #   Model.publishDestroy matchingRecords.id, not sails.config.blueprints.mirror and req,
      #     previous: matchingRecords

      #   if req.isSocket
      #     Model.unsubscribe req, matchingRecords
      #     Model.retire matchingRecords

      return res.ok matchingRecords



  # Model = actionUtil.parseModel(req);
  # # TODO: don't use url params. Use object instead
  # query = Model.find().where(actionUtil.parseCriteria(req)).limit(actionUtil.parseLimit(req)).skip(actionUtil.parseSkip(req)).sort(actionUtil.parseSort(req))

  # query = actionUtil.populateEach(query, req)
  # query.exec (err, matchingRecords) ->
  #   return res.serverError(err)  if err

  #   Model.destroy(query).exec (record) ->
  #     return res.serverError(err)  if err
  #     res.ok record






  #   # What happens if don't find the user?

  #   Model.destroy(query).exec (record) ->
  #     return res.serverError(err)  if err
  #     res.ok record

  # user          = {}
  # user.id       = req.param('id') if req.param('id')
  # user.username = req.param('username') if req.param('username')
  # user.email    = req.param('email') if req.param('email')

  # query = User.findOne(user)
  # query = sailor.actionUtil.populateEach(query, req)

  # query.exec foundRecord = (err, record) ->

  #   return res.notFound("No record found with the specified `id`.")  unless record
  #   User.destroy(user).exec destroyedRecord = (err) ->
  #     return res.negotiate(err)  if err


