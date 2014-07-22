validator         = require "validator"
errorify          = require "sailor-errorify"

###
Local Authentication Protocol

The most widely used way for websites to authenticate users is via a username
and/or email as well as a password. This module provides functions both for
registering entirely new users, assigning passwords to already registered
users and validating login requesting.

For more information on local authentication in Passport.js, check out:
http://passportjs.org/guide/username-password/
###

###
Register a new user

This method creates a new user from a specified email, username and password
and assign the newly created user a local Passport.

@param {Object}   req
@param {Object}   res
@param {Function} next
###
exports.register = (req, res, next) ->

  password = req.param("password")
  username = req.param("username")
  email    = req.param("email")

  # TODO: Use Waterline Error Factory
  # The email is validate in the model, but not the password in local strategy
  unless password

    ## Testing normal error
    # error = errorify.error()

    ## Testing validation error
    attr1 =
      name: "test"
      rule: "rule"
      message: "User.Password.NotFound"

    attr2 =
      name: "test_2"
      rule: "rule_2"
      message: "@Kikobeats"

    error = errorify.errorValidation(
      model : "User"
      attributes: [attr1, attr2]
    )
    return next(error)

  user =
    email: email
    username: username

  User.create(user).exec (err, user) ->
    # TODO: Use Waterline Error Factory
    return next(err, user)  if err

    strategy =
      protocol: "local"
      password: password
      user: user.id

    Passport.create(strategy).exec (err, passport) ->
      # TODO: Use Waterline Error Factory
      next err, user

###
Assign local Passport to user

This function can be used to assign a local Passport to a user who doens't
have one already. This would be the case if the user registered using a
third-party service and therefore never set a password.

@param {Object}   req
@param {Object}   res
@param {Function} next
###
exports.connect = (req, res, next) ->
  user = req.user
  password = req.param("password")
  Passport.findOne
    protocol: "local"
    user: user.id
  , (err, passport) ->
    return next(err)  if err
    unless passport
      Passport.create
        protocol: "local"
        password: password
        user: user.id
      , (err, passport) ->
        console.log "Se queda aqui"
        next err, user
        return

    else
      next sails.__("Error.Passport.Strategy.Already"), user
    return

  return


###
Validate a login request

Looks up a user using the supplied identifier (email or username) and then
attempts to find a local Passport associated with the user. If a Passport is
found, its password is checked against the password supplied in the form.

@param {Object}   req
@param {string}   identifier
@param {string}   password
@param {Function} next
###
exports.login = (req, identifier, password, next) ->
  isEmail = validator.isEmail(identifier)
  user = {}
  if isEmail
    user.email = identifier
  else
    user.username = identifier
  User.findOne user, (err, user) ->
    return next(err)  if err

    # TODO: Cambiar por sailor-stringfile
    return next(sails.__("Error.Passport.User.NotFound"), user)  unless user
    Passport.findOne
      protocol: "local"
      user: user.id
    , (err, passport) ->
      next err  if err
      if passport
        passport.validatePassword password, (err, res) ->
          return next(err)  if err
          unless res
            errMessage = sails.__("Error.Passport.Password.Wrong")
            next errMessage
          else
            next null, user

      else
        errMessage = sails.__("Error.Passport.Password.NotSet")
        next errMessage
      return

    return

  return
