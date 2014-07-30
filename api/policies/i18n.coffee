###
i18n Middleware

Middleware for extract the language for the URL and setup

@param {Object}   req
@param {Object}   res
@param {Function} next
###
module.exports = (req, res, next) ->

  lang = req.param("lang")

  req.language = lang
  req.region   = region

  next()
