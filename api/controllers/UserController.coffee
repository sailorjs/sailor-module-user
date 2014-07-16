validator  = require 'validator'

###
Authentication Controller

This is merely meant as an example of how your Authentication controller
should look. It currently includes the minimum amount of functionality for
the basics of Passport.js to work.
###
module.exports =

  ###
  Log out a user and return them to the homepage

  Passport exposes a logout() function on req (also aliased as logOut()) that
  can be called from any route handler which needs to terminate a login
  session. Invoking logout() will remove the req.user property and clear the
  login session (if any).

  For more information on logging out users in Passport.js, check out:
  http://passportjs.org/guide/logout/

  @param {Object} req
  @param {Object} res
  ###
  logout: (req, res) ->
    req.logout()
    res.ok()

  ###
  Localize and delete a user from the system.
  Is necessary the email or the username to proceed it.
  @param  {[type]} req [description]
  @param  {[type]} res [description]
  @return {[type]} staths [description]
  ###
  destroy: (req, res) ->
    identifier = req.param("identifier")
    isEmail = validator.isEmail(identifier)
    user = {}

    if isEmail
      user.email = identifier
    else
      user.username = identifier

    User.findOne user, (err, user) ->
      return res.negotiate(err)  if err
      return res.badRequest("User not found")  unless user
      User.destroy user.id, (err) ->
        return res.negotiate(err)  if err
        res.ok user

  ###
  Create a third-party authentication endpoint

  @param {Object} req
  @param {Object} res
  ###
  provider: (req, res) ->
    passport.endpoint req, res

  ###
  Create a authentication callback endpoint

  This endpoint handles everything related to creating and verifying Pass-
  ports and users, both locally and from third-aprty providers.

  Passport exposes a login() function on req (also aliased as logIn()) that
  can be used to establish a login session. When the login operation
  completes, user will be assigned to req.user.

  For more information on logging in users in Passport.js, check out:
  http://passportjs.org/guide/login/

  @param {Object} req
  @param {Object} res
  ###
  callback: (req, res) ->
    passport.callback req, res, (err, user) ->
      return res.badRequest(err)  if err
      req.login user, (err) ->
        return res.badRequest err if err
        res.ok()
