###
Dependencies
###
sailor    = require 'sailorjs'
translate = sailor.translate

module.exports = (sails) ->
  initialize: (cb) ->
    translate.add sails.config.translations
    sails.services.passport.loadStrategies()
    cb()
