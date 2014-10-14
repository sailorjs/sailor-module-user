###
Dependencies
###
path     = require 'path'
url      = require 'url'
passport = require 'passport'

#
# Passport Service
#
# A painless Passport.js service for your Sails app that is guaranteed to
# Rock Your Socks™. It takes all the hassle out of setting up Passport.js by
# encapsulating all the boring stuff in two functions:
#
# passport.endpoint()
# passport.callback()
#
# The former sets up an endpoint (/auth/:provider) for redirecting a user to a
# third-party provider for authentication, while the latter sets up a callback
# endpoint (/auth/:provider/callback) for receiving the response from the
# third-party provider. All you have to do is define in the configuration which
# third-party providers you'd like to support. It's that easy!
#
# Behind the scenes, the service stores all the data it needs within "Pass-
# ports". These contain all the information required to associate a local user
# with a profile from a third-party provider. This even holds true for the good
# ol' password authentication scheme – the Authentication Service takes care of
# encrypting passwords and storing them in Passports, allowing you to keep your
# User model free of bloat.
#
passport.protocols = require("./protocols")

#
# Connect a third-party profile to a local user
#
# This is where most of the magic happens when a user is authenticating with a
# third-party provider. What it does, is the following:
#
# 1. Given a provider and an identifier, find a mathcing Passport.
# 2. From here, the logic branches into two paths.
#
# - A user is not currently logged in:
# 1. If a Passport wassn't found, create a new user as well as a new
# Passport that will be assigned to the user.
# 2. If a Passport was found, get the user associated with the passport.
#
# - A user is currently logged in:
# 1. If a Passport wasn't found, create a new Passport and associate it
# with the already logged in user (ie. "Connect")
# 2. If a Passport was found, nothing needs to happen.
#
# As you can see, this function handles both "authentication" and "authori-
# zation" at the same time. This is due to the fact that we pass in
# `passReqToCallback: true` when loading the strategies, allowing us to look
# for an existing session in the request and taking action based on that.
#
# For more information on auth(entication|rization) in Passport.js, check out:
# http://passportjs.org/guide/authenticate/
# http://passportjs.org/guide/authorize/
#
# @param {Object}   req
# @param {Object}   query
# @param {Object}   profile
# @param {Function} next
#
passport.connect = (req, query, profile, next) ->
  user     = {}

  # Get the authentication strategy from the query.
  query.strategy = req.param "strategy"

  # Use profile.strategy or fallback to the query.strategy if it is undefined
  # as is the case for OpenID, for example
  strategy = profile.strategy or query.strategy

  # If the strategy cannot be identified we cannot match it to a passport so
  # throw an error and let whoever's next in line take care of it.
  return next(new Error("No authentication strategy was identified.")) unless strategy

  # If the profile object contains a list of emails, grab the first one and
  # add it to the user.
  user.email = profile.emails[0].value if profile.hasOwnProperty("emails")

  # If the profile object contains a username, add it to the user.
  user.username = profile.username if profile.hasOwnProperty("username")

  # If neither an email or a username was available in the profile, we don't
  # have a way of identifying the user in the future. Throw an error and let
  # whoever's next in the line take care of it.
  return next(new Error("Neither a username nor email was available")) if not user.username and not user.email

  obj =
    strategy: profile.strategy
    identifier: query.identifier.toString()

  Passport.findOne obj, (err, passport) ->
    return next(err) if err
    unless req.user
      unless passport
        User.create user, (err, user) ->
          return next(err) if err
          query.user = user.id
          Passport.create query, (err, passport) ->
            return next(err)  if err
            next err, user
      else
        passport.tokens = query.tokens  if query.hasOwnProperty("tokens") and query.tokens isnt passport.tokens
        passport.save (err, passport) ->
          return next(err)  if err
          User.findOne passport.user, next
    else
      unless passport
        query.user = req.user.id
        Passport.create query, (err, passport) ->
          return next(err)  if err
          next err, req.user
      else
        next null, req.user

#
# Create an authentication endpoint
#
# For more information on authentication in Passport.js, check out:
# http://passportjs.org/guide/authenticate/
#
# @param  {Object} req
# @param  {Object} res
#
passport.endpoint = (req, res) ->
  strategies = sails.config.passport
  strategy   = req.param("strategy")
  options    = {}

  return res.redirect("/login")  unless strategies.hasOwnProperty(strategy)
  options.scope = strategies[strategy].scope  if strategies[strategy].hasOwnProperty("scope")
  @authenticate(strategy, options) req, res, req.next


#
# Create an authentication callback endpoint
#
# For more information on authentication in Passport.js, check out:
# http://passportjs.org/guide/authenticate/
#
# @param {Object}   req
# @param {Object}   res
# @param {Function} next
#
passport.callback = (req, res, next) ->
  method   = req.method
  strategy = if req.param 'strategy' then req.param 'strategy' else 'local'
  action   = if req.param 'action' then req.param 'action' else 'create'

  sails.log.debug "Passport.callback :: Method [#{method}] Action [#{action}], Strategy [#{strategy}]"

  # Passport.js wasn't really built for local user registration, but it's nice
  # having it tied into everything else.

  if strategy is 'local'
    if action is 'create'
      return @protocols.local.register req, res, next
    else if action is 'connect'
      return @protocols.local.register req, res, next
    else if action is 'login'
      return @protocols.local.login req, res, next
    else
      next new Error("Invalid action")

    # The strategy will redirect the user to this URL after approval. Finish
    # the authentication process by attempting to obtain an access token. If
    # access was granted, the user will be logged in. Otherwise, authentication
    # has failed.
  else
    @authenticate(strategy, next) req, res, req.next

#
# Load all strategies defined in the Passport configuration
#
# For example, we could add this to our config to use the GitHub strategy
# with permission to access a users email address (even if it's marked as
# private) as well as permission to add and update a user's Gists:
#
# github: {
#   name: 'GitHub',
#   protocol: 'oauth2',
#   scope: [ 'user', 'gist' ]
#   options: {
#     clientID: 'CLIENT_ID',
#     clientSecret: 'CLIENT_SECRET'
#    }
# }
#
# For more information on the strategys supported by Passport.js, check out:
# http://passportjs.org/guide/strategys/
#
passport.loadStrategies = ->
  self       = this
  strategies = sails.config.passport

  Object.keys(strategies).forEach (key) ->
    options = passReqToCallback: true

    if key is "local"
      _.extend options,
        usernameField: "identifier"

      if strategies.local
        Strategy = strategies[key].strategy
        self.use new Strategy(options, self.protocols.local.login)
    else
      protocol = strategies[key].protocol
      callback = strategies[key].callback
      callback = path.join("auth", key, "callback")  unless callback
      Strategy = strategies[key].strategy
      baseUrl  = sails.getBaseurl()

      switch protocol
        when "oauth", "oauth2"
          options.callbackURL = url.resolve(baseUrl, callback)
        when "openid"
          options.returnURL = url.resolve(baseUrl, callback)
          options.realm     = baseUrl
          options.profile   = true

      _.extend options, strategies[key].options
      self.use new Strategy(options, self.protocols[protocol])

###
Disconnect a passport from a user

@param  {Object} req
@param  {Object} res
###
passport.disconnect = (req, res, next) ->
  user     = req.user
  strategy = req.param("strategy")

  obj =
    strategy: strategy
    user: user.id

  Passport.findOne obj, (err, passport) ->
    return next(err)  if err
    Passport.destroy passport.id, (error) ->
      return next(err)  if err
      next null, user

passport.serializeUser (user, next) ->
  next null, user.id

passport.deserializeUser (id, next) ->
  User.findOne id, (err, user) ->
    next(err, user)

###
Exports
###
module.exports = passport
