###
Dependencies
###
sailor  = require 'sailorjs'
translate = sailor.translate

###
Utils
###
_extendReq = (req) ->

  req.login = req.logIn = (user, options, done) ->

    if typeof options is "function"
      done = options
      options = {}

    options = options or {}
    property = "user"
    property = req._passport.instance._userProperty or "user"  if req._passport and req._passport.instance
    session = (if (options.session is `undefined`) then true else options.session)
    req[property] = user
    return done and done()  unless session

    throw new Error("passport.initialize() middleware not in use")  unless req._passport
    throw new Error("req#login requires a callback function")  unless typeof done is "function"

    user.onLogin (err, user) ->
      req._passport.instance.serializeUser user, req, (err, obj) ->
        if err
          req[property] = null
          return done(err)
        req._passport.session.user = obj
        done()

  req.logout = req.logOut = ->
    req.user.onLogout (err, user) ->
      property = "user"
      property = req._passport.instance._userProperty or "user"  if req._passport and req._passport.instance
      req[property] = null
      delete req._passport.session.user  if req._passport and req._passport.session
      req.session.destroy()

  req.isAuthenticated = ->
    property = 'user'
    property = req._passport.instance._userProperty || 'user' if (req._passport && req._passport.instance)
    (req[property]) ? true : false

  req.isUnauthenticated = ->
    !req.isAuthenticated()

  req

###
Exports
###
module.exports = (sails) ->

  initialize: (cb) ->
    sails.services.passport.loadStrategies()
    cb()

  routes:
    before:
      "*": configurePassport = (req, res, next) ->
        req = _extendReq(req)
        passport.initialize() req, res, (err) ->
          return res.negotiate(err)  if err
          passport.session() req, res, (err) ->
            return res.negotiate(err)  if err
            # Make the user available throughout the frontend
            res.locals.user = req.user
            next()
