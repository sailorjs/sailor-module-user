###
Dependencies
###
sailor    = require 'sailorjs'
translate = sailor.translate

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
  lang     = req.param 'lang'

  # console.log "DEBUG ::"
  # console.log sails
  # console.log _default
  # console.log locales
  # console.log lang

  unless lang?
    # try to recover the lang from the path
    path = req.route.path.split("/")[1]
    valid = true for local in locales when "/#{path}/" is local
    # if is not possible try to set the best language for the user
    if valid
      lang = path
    else
      lang = req.language or translate.default()

  # updated the language in `req` and `translate`
  req.language = lang
  req.region   = lang
  translate.lang lang
  req.params.lang ?= lang

  sails.log.debug "i18n Middleware :: Language is #{lang}"
  next()
