sailor   = require 'sailorjs'

###
Destroy Blueprint
Destroy the user and the Model associated with the User
###
module.exports = (req, res) ->
  user     = {}
  user.id = req.param('id') if req.param('id')
  user.username = req.param('username') if req.param('username')
  user.email = req.param('email') if req.param('email')

  query = User.findOne(user)
  query = sailor.actionUtil.populateEach(query, req)

  query.exec foundRecord = (err, record) ->
    return res.serverError(err)  if err
    return res.notFound("No record found with the specified `id`.")  unless record
    User.destroy(user).exec destroyedRecord = (err) ->
      return res.negotiate(err)  if err

      res.ok record

  # console.log "HERE"

  # pk  = sailor.actionUtil.requirePk(req)
  # console.log pk
  # query = User.findOne(pk)
  # console.log query
  # query = sailor.actionUtil.populateEach(query, req)
  # console.log query

  # query.exec (err, record) ->
  #   console.log err
  #   console.log record
  #   res.ok record

    # return res.serverError(err)  if err
    # msg_err = sailor.translate.get("User.Username.NotFound")
    # return res.notFound(msg_err)  unless record

    # User.destroy(query).exec (err) ->
    #   return res.negotiate(err)  if err

    #   ## TODO: Delete Passport associated
    #   res.ok record



# module.exports = destroyOneRecord = (req, res) ->
#   Model = actionUtil.parseModel(req)
#   pk = actionUtil.requirePk(req)
#   query = Model.findOne(pk)
#   query = actionUtil.populateEach(query, req)

#   query.exec foundRecord = (err, record) ->
#     return res.serverError(err)  if err
#     return res.notFound("No record found with the specified `id`.")  unless record
#     Model.destroy(pk).exec destroyedRecord = (err) ->
#       return res.negotiate(err)  if err
#       if sails.hooks.pubsub
#         Model.publishDestroy pk, not sails.config.blueprints.mirror and req,
#           previous: record

#         if req.isSocket
#           Model.unsubscribe req, record
#           Model.retire record
#       res.ok record

#     return

#   return
