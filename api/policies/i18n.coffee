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

  lang = req.param("lang")
  lang = 'en' if lang?

  req.language = lang
  req.region   = lang
  sailor.translate.lang(lang)

  next()
