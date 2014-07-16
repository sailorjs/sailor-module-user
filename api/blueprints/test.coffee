###
Create Record

post /:modelIdentity

An API call to find and return a single model instance from the data adapter
using the specified criteria.  If an id was specified, just the instance with
that unique id will be returned.

Optional:
@param {String} callback - default jsonp callback param (i.e. the name of the js function returned)
@param {*} * - other params will be used as `values` in the create
###
module.exports = createRecord = (req, res) ->
  res.status 201
  res.ok "Hello world"
  return
