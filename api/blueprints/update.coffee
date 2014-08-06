###
Module dependencies
###
sailor     = require 'sailorjs'
actionUtil = sailor.actionUtil
translate  = sailor.translate
validator  = sailor.validator
errorify   = sailor.errorify

###
Update One Record

An API call to update a model instance with the specified `id`,
treating the other unbound parameters as attributes.

@param {Integer|String} id  - the unique id of the particular record you'd like to update  (Note: this param should be specified even if primary key is not `id`!!)
@param *                    - values to set on the record
###
module.exports = (req, res) ->

  # Look up the model
  Model = actionUtil.parseModel(req)

  # Locate and validate the required `id` parameter.
  pk = actionUtil.requirePk(req)

  # Create `values` object (monolithic combination of all parameters)
  # But omit the blacklisted params (like JSONP callback param, etc.)
  values = actionUtil.parseValues(req)

  # Omit the path parameter `id` from values, unless it was explicitly defined
  # elsewhere (body/query):
  idParamExplicitlyIncluded = ((req.body and req.body.id) or req.query.id)
  delete values.id  unless idParamExplicitlyIncluded

  # Find and update the targeted record.
  #
  # (Note: this could be achieved in a single query, but a separate `findOne`
  #  is used first to provide a better experience for front-end developers
  #  integrating with the blueprint API.)
  Model.findOne(pk).populateAll().exec (err, matchingRecord) ->
    return res.serverError(err)  if err
    return res.notFound()  unless matchingRecord
    Model.update(pk, values).exec (err, records) ->

      # Differentiate between waterline-originated validation errors
      # and serious underlying issues. Respond with badRequest if a
      # validation error is encountered, w/ validation info.
      return res.negotiate(err)  if err

      # Because this should only update a single record and update
      # returns an array, just use the first item.  If more than one
      # record was returned, something is amiss.
      req._sails.log.warn util.format("Unexpected output from `%s.update`.", Model.globalId)  if not records or not records.length or records.length > 1
      updatedRecord = records[0]

      # If we have the pubsub hook, use the Model's publish method
      # to notify all subscribers about the update.
      if req._sails.hooks.pubsub
        Model.subscribe req, records  if req.isSocket
        Model.publishUpdate pk, _.cloneDeep(values), not req.options.mirror and req,
          previous: matchingRecord.toJSON()

      res.ok updatedRecord
