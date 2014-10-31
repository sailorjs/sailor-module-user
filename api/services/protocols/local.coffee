###
Dependencies
###
sailor    = require 'sailorjs'
translate = sailor.translate
errorify  = sailor.errorify
validator = sailor.validator

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

  passwordLength = Passport._attributes.password.minLength
  validator
    .begin(req, res)
    .add 'email', translate.get('User.Email.NotFound'), 'notEmpty'
    .add 'password', translate.get('User.Password.NotFound'), 'notEmpty'
    .add 'password', translate.get('User.Password.Invalid'), 'isAlphanumeric'
    .add 'password', translate.get('User.Password.MinLength'), 'isLength', passwordLength
    .end (params) ->
      user =
        email: params.email
        username: req.param 'username'

      User.create(user).exec (err, user) ->
        return next(err, user) if err

        strategy =
          protocol: "local"
          password: params.password
          user:     user.id

        Passport.create(strategy).exec (err, passport) ->
          if err
            user.destroy (destroyErr) ->
              next destroyErr or err
          user.context = 'register'
          next null, user

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
  user     = req.user
  password = req.param("password")

  user =
    protocol: "local"
    user: user.id

  Passport.findOne(user).exec (err, passport) ->
    return next(err) if err

    unless passport
      passport =
        protocol: "local"
        password: password
        user: user.id

      Passport.create(passport).exec (err, passport) ->
        next err, user

    else
      next null, user

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
exports.login = (req, res, next) ->
  validator
    .begin(req, res)
    .add 'identifier', translate.get('User.Identifier.NotFound'), 'notEmpty'
    .add 'password', translate.get('User.Password.NotFound'), 'notEmpty'
    .end (params) ->
      user    = {}
      isEmail = validator.isEmail(params.identifier)
      if isEmail then user.email = params.identifier else user.username = params.identifier

      User.findOne(user).exec (err, user) ->
        return serverError(err)  if err

        unless user
          return errorify
          .add 'identifier', translate.get('User.NotFound'), user
          .end res, 'notFound'

        passport =
          protocol: "local"
          user: user.id

        Passport.findOne(passport).exec (err, passport) ->
          return serverError(err)  if err

          unless passport
            return errorify
            .add 'strategy', translate.get('User.Strategy.NotSet'), user
            .end res, 'notFound'

          passport.validatePassword params.password, (err, valid) ->
            return next(err)  if err

            unless valid
              return errorify
              .add 'password', translate.get('User.Password.DontMatch'), user
              .end res, 'notFound'

            # NOTE
            # in pure REST, only transfer the token and the client need to do another
            # findOne request to get the user, but provide both in the same request.
            # _.assign(user, JWTService.encode(id: user.id))
            user.context = 'login'
            next null, user
