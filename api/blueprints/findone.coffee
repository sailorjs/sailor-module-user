###
Module dependencies
###
sailor     = require 'sailorjs'
actionUtil = sailor.actionUtil
translate  = sailor.translate
validator  = sailor.validator
errorify   = sailor.errorify

###
Find One Record

get /:modelIdentity/:id

An API call to find and return a single model instance from the data adapter
using the specified id.

Required:
@param {Integer|String} id  - the unique id of the particular instance you'd like to look up *

Optional:
@param {String} callback - default jsonp callback param (i.e. the name of the js function returned)
###
module.exports = (req, res) ->

  Model = actionUtil.parseModel(req)
  pk    = actionUtil.requirePk(req)
  query = Model.findOne(pk).populateAll()

  query.exec (err, matchingRecord) ->
    return res.serverError(err)  if err

    unless matchingRecord
      name = sailor.capitalize(Model.identity)
      err = msg: translate.get("#{name}.NotFound")
      return res.notFound(errorify.serialize(err))

    if sails.hooks.pubsub and req.isSocket
      Model.subscribe req, matchingRecord
      actionUtil.subscribeDeep req, matchingRecord

    res.ok matchingRecord
