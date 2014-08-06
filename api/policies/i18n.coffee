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

  sails    = req._sails
  locales  = sails.config.i18n.locales
  _default = sailor.translate.get_default()
  lang     = req.param("lang")

  unless lang?
    # try to recover the lang from the path
    path = req.route.path.split("/")[1]
    valid = true for local in locales when "/#{path}/" is local
    if valid then lang = path else lang = _default

  req.language = lang
  req.region   = lang
  sailor.translate.lang(lang)

  req.params.lang ?= lang

  sails.log.debug "i18n Middleware :: Language is #{lang}"

  next()
