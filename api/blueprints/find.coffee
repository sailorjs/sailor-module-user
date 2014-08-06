###
Module dependencies
###
sailor     = require 'sailorjs'
actionUtil = sailor.actionUtil
translate  = sailor.translate
validator  = sailor.validator

###
Find Records

get   /:modelIdentity
/:modelIdentity/find

An API call to find and return model instances from the data adapter
using the specified criteria.  If an id was specified, just the instance
with that unique id will be returned.

Optional:
@param {Object} where       - the find criteria (passed directly to the ORM)
@param {Integer} limit      - the maximum number of records to send back (useful for pagination)
@param {Integer} skip       - the number of records to skip (useful for pagination)
@param {String} sort        - the order of returned records, e.g. `name ASC` or `age DESC`
@param {String} callback - default jsonp callback param (i.e. the name of the js function returned)
###
module.exports =  (req, res) ->

  # Look up the model
  Model = actionUtil.parseModel(req)

  # If an `id` param was specified, use the findOne blueprint action
  # to grab the particular instance with its primary key === the value
  # of the `id` param.   (mainly here for compatibility for 0.9, where
  # there was no separate `findOne` action)
  return require("./findOne")(req, res) if actionUtil.parsePk(req)

  # Lookup for records that match the specified criteria
  query = Model.find().where(actionUtil.parseCriteria(req)).limit(actionUtil.parseLimit(req)).skip(actionUtil.parseSkip(req)).sort(actionUtil.parseSort(req))
  query = query.populateAll()
  query.exec (err, matchingRecords) ->
    return res.serverError(err)  if err

    # Only `.watch()` for new instances of the model if
    # `autoWatch` is enabled.
    if req._sails.hooks.pubsub and req.isSocket
      Model.subscribe req, matchingRecords
      Model.watch req  if req.options.autoWatch

      # Also subscribe to instances of all associated models
      _.each matchingRecords, (record) ->
        actionUtil.subscribeDeep req, record

    if matchingRecords.length is 0
      name = sailor.capitalize(Model.identity)
      err = msg: translate.get("#{name}.NotFound")
      res.notFound(sailor.errorify.serialize(err))
    else
      res.ok matchingRecords
