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
    user = req.user
    return res.invalid() unless user
    req.logout()
    res.ok(user)

  session: (req, res) ->
    return res.ok(req.user) if req.user?
    res.invalid()

  ###
  Create a third-party authentication endpoint

  @param {Object} req
  @param {Object} res
  ###
  strategy: (req, res) ->
    passport.endpoint req, res

  ###
  Disconnect a passport from a user

  @param {Object} req
  @param {Object} res
  ###
  disconnect: (req, res) ->
    passport.disconnect req, res

  ###
  Create a authentication callback endpoint

  This endpoint handles everything related to creating and verifying Pass-
  ports and users, both locally and from third-aprty strategies.

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
      req.logIn user, (err) ->
        return res.badRequest(err)  if err
        res.ok(user)
