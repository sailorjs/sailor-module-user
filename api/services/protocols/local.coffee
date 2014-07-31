###
Dependencies
###
sailor = require 'sailorjs'

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

  unless password
    return next(sailor.errorify.errorValidation(
      model : "User"
      attributes: [
        name: "Password"
        rule: "DontMatch"
        message: sailor.translate.get('User.Password.DontMatch')
      ]
    ))

  user =
    email: email
    username: username

  User.create(user).exec (err, user) ->
    return next(err, user)  if err

    strategy =
      protocol: "local"
      password: password
      user:     user.id

    Passport.create(strategy).exec (err, passport) ->
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
  user     = req.user
  password = req.param("password")

  user =
    protocol: "local"
    user: user.id

  Passport.findOne(user).exec (err, passport) ->
    return next(err)  if err

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
exports.login = (req, identifier, password, next) ->

  isEmail = sailor.validator.isEmail(identifier)
  user    = {}

  if isEmail
    user.email = identifier
  else
    user.username = identifier

  User.findOne(user).exec (err, user) ->
    return next(err)  if err
    unless user
      return next(sailor.errorify.errorValidation(
        model : "User"
        attributes: [
          name: "User"
          rule: "Doesn't Found"
          message: sailor.translate.get('User.Username.NotFound')
        ]))

    passport =
      protocol: "local"
      user: user.id

    Passport.findOne(passport).exec (err, passport) ->
      return next(err) if err

      if passport
        passport.validatePassword password, (err, res) ->
          return next(err)  if err
          unless res
            return next(sailor.errorify.errorValidation(
              model : "User"
              attributes: [
                name: "Strategy"
                rule: "Doesn't Match"
                message: sailor.translate.get('User.Password.DontMatch')
              ]))
          else
            return next null, user
      else
        return next(sailor.errorify.errorValidation(
          model : "User"
          attributes: [
            name: "Strategy"
            rule: "Doesn't Set"
            message: sailor.translate.get('User.Strategy.NotSet')
          ]))
