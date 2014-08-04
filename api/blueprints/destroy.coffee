sailor   = require 'sailorjs'

###
Destroy Blueprint
Destroy the user and the Model associated with the User
###
module.exports = (req, res) ->

  id = req.param('id')
  # console.log req
  return res.badRequest() unless id

  query = User.findOne(id)
  query = sailor.actionUtil.populateEach(query, req)

  query.exec (err, record) ->
    return res.serverError(err)  if err
    return res.notFound("No record found with the specified `id`.")  unless record

    User.destroy(id).exec (err) ->
      return res.negotiate(err)  if err

      ## TODO: Delete Passport associated
      res.ok record
