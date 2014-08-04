###
Dependencies
###
sailor = require 'sailorjs'

###
i18n Middleware

Middleware for extract the language for the URL and setup
i18n

@param {Object}   req
@param {Object}   res
@param {Function} next
###
module.exports = (req, res, next) ->

  _default = sailor.translate.get_default()

  lang = req.param("lang") or _default
  req.language = lang
  req.region   = lang
  sailor.translate.lang(lang)

  req.params.lang ?= lang

  req._sails.log.debug "i18n Middleware :: Language is #{lang}"

  next()
