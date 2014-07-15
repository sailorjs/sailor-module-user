path = require("path")
url = require("url")
passport = require("passport")

#
#Passport Service
#
#A painless Passport.js service for your Sails app that is guaranteed to
#Rock Your Socks™. It takes all the hassle out of setting up Passport.js by
#encapsulating all the boring stuff in two functions:
#
#passport.endpoint()
#passport.callback()
#
#The former sets up an endpoint (/auth/:provider) for redirecting a user to a
#third-party provider for authentication, while the latter sets up a callback
#endpoint (/auth/:provider/callback) for receiving the response from the
#third-party provider. All you have to do is define in the configuration which
#third-party providers you'd like to support. It's that easy!
#
#Behind the scenes, the service stores all the data it needs within "Pass-
#ports". These contain all the information required to associate a local user
#with a profile from a third-party provider. This even holds true for the good
#ol' password authentication scheme – the Authentication Service takes care of
#encrypting passwords and storing them in Passports, allowing you to keep your
#User model free of bloat.
#
passport.protocols = require("./protocols")

#
#Connect a third-party profile to a local user
#
#This is where most of the magic happens when a user is authenticating with a
#third-party provider. What it does, is the following:
#
#1. Given a provider and an identifier, find a mathcing Passport.
#2. From here, the logic branches into two paths.
#
#- A user is not currently logged in:
#1. If a Passport wassn't found, create a new user as well as a new
#Passport that will be assigned to the user.
#2. If a Passport was found, get the user associated with the passport.
#
#- A user is currently logged in:
#1. If a Passport wasn't found, create a new Passport and associate it
#with the already logged in user (ie. "Connect")
#2. If a Passport was found, nothing needs to happen.
#
#As you can see, this function handles both "authentication" and "authori-
#zation" at the same time. This is due to the fact that we pass in
#`passReqToCallback: true` when loading the strategies, allowing us to look
#for an existing session in the request and taking action based on that.
#
#For more information on auth(entication|rization) in Passport.js, check out:
#http://passportjs.org/guide/authenticate/
#http://passportjs.org/guide/authorize/
#
#@param {Object}   req
#@param {Object}   query
#@param {Object}   profile
#@param {Function} next
#
passport.connect = (req, query, profile, next) ->
  config = undefined
  strategies = undefined
  user = undefined
  strategies = sails.config.passport
  config = strategies[profile.provider]
  user = {}
  query.provider = req.param("provider")
  user.email = profile.emails[0].value  if profile.hasOwnProperty("emails")
  user.username = profile.username  if profile.hasOwnProperty("username")
  return next(new Error("Neither a username nor email was available"))  if not user.username and not user.email
  Passport.findOne
    provider: profile.provider
    identifier: query.identifier.toString()
  , (err, passport) ->
    return next(err)  if err
    unless req.user
      unless passport
        User.create user, (err, user) ->
          if err
            req.flash "error", ((if err.invalidAttributes.email then "Error.Passport.Email.Exists" else "Error.Passport.User.Exists"))  if err.code is "E_VALIDATION"
            return next(err)
          query.user = user.id
          Passport.create query, (err, passport) ->
            return next(err)  if err
            next err, user
            return

          return

      else
        passport.tokens = query.tokens  if query.hasOwnProperty("tokens") and query.tokens isnt passport.tokens
        passport.save (err, passport) ->
          return next(err)  if err
          User.findOne passport.user, next
          return

    else
      unless passport
        query.user = req.user.id
        Passport.create query, (err, passport) ->
          return next(err)  if err
          next err, req.user
          return

      else
        next null, req.user
    return

  return


#
#Create an authentication endpoint
#
#For more information on authentication in Passport.js, check out:
#http://passportjs.org/guide/authenticate/
#
#@param  {Object} req
#@param  {Object} res
#
passport.endpoint = (req, res) ->
  options = undefined
  provider = undefined
  strategies = undefined
  strategies = sails.config.passport
  provider = req.param("provider")
  options = {}
  return res.redirect("/login")  unless strategies.hasOwnProperty(provider)
  options.scope = strategies[provider].scope  if strategies[provider].hasOwnProperty("scope")
  @authenticate(provider, options) req, res, req.next


#
#Create an authentication callback endpoint
#
#For more information on authentication in Passport.js, check out:
#http://passportjs.org/guide/authenticate/
#
#@param {Object}   req
#@param {Object}   res
#@param {Function} next
#
passport.callback = (req, res, next) ->
  # e.g. /user/create and get 'create'
  action     = req.path.split("/")[2]
  # Local is the default strategy
  strategy   = req.param("strategy", "local")

  sails.log.debug "Passport.callback:: #{action}, #{strategy}"

  if strategy is "local" and action isnt `undefined`
    if action is "create" and not req.user
      @protocols.local.register req, res, next
    else if action is "connect" and req.user
      @protocols.local.connect req, res, next
    else
      next "Invalid action"
  else
    @authenticate(provider, next) req, res, req.next


  # if provider is "local" and action isnt `undefined`
  #   if action is "register" and not req.user
  #     @protocols.local.register req, res, next
  #   else if action is "connect" and req.user
  #     @protocols.local.connect req, res, next
  #   else
  #     next "Invalid action"
  # else
  #   @authenticate(provider, next) req, res, req.next


#
#Load all strategies defined in the Passport configuration
#
#For example, we could add this to our config to use the GitHub strategy
#with permission to access a users email address (even if it's marked as
#private) as well as permission to add and update a user's Gists:
#
#github: {
#name: 'GitHub',
#protocol: 'oauth2',
#scope: [ 'user', 'gist' ]
#options: {
#clientID: 'CLIENT_ID',
#clientSecret: 'CLIENT_SECRET'
#}
#}
#
#For more information on the providers supported by Passport.js, check out:
#http://passportjs.org/guide/providers/
#
passport.loadStrategies = ->
  self = undefined
  strategies = undefined
  self = this
  strategies = sails.config.passport
  Object.keys(strategies).forEach (key) ->
    Strategy = undefined
    baseUrl = undefined
    callback = undefined
    options = undefined
    protocol = undefined
    options = passReqToCallback: true
    Strategy = undefined
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
      baseUrl = sails.getBaseurl()
      switch protocol
        when "oauth", "oauth2"
          options.callbackURL = url.resolve(baseUrl, callback)
        when "openid"
          options.returnURL = url.resolve(baseUrl, callback)
          options.realm = baseUrl
          options.profile = true
      _.extend options, strategies[key].options
      self.use new Strategy(options, self.protocols[protocol])


passport.serializeUser (user, next) ->
  next null, user.id

passport.deserializeUser (id, next) ->
  User.findOne id, next

module.exports = passport
