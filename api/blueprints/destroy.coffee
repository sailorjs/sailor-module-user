sailor   = require 'sailorjs'

###
Destroy Blueprint
Destroy the user and the Model associated with the User
###
module.exports = (req, res) ->
  pk = sailor.actionUtil.requirePk(req)
  query = User.findOne(pk)
  query = sailor.actionUtil.populateEach(query, req)
  query.exec (err, record) ->
    return res.serverError(err)  if err
    # TODO Multilang
    return res.notFound("No record found with the specified `id`.")  unless record

    User.destroy(pk).exec (err) ->
      return res.negotiate(err)  if err

      ## TODO: Delete Passport associated
      res.ok record
