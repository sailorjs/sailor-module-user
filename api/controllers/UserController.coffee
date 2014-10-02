## -- Dependencies -------------------------------------------------------------

sailor     = require 'sailorjs'
validator  = sailor.validator
actionUtil = sailor.actionUtil
translate  = sailor.translate
errorify   = sailor.errorify

## -- Exports -------------------------------------------------------------

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

  getFollowers: (req, res) ->
    data = actionUtil.parseValues(req)
    User.findOne(data).exec (err, user) ->
      return res.badRequest(err)  if err
      res.ok(do user.getFollowers)

  getFollowings: (req, res) ->
    data = actionUtil.parseValues(req)
    User.findOne(data).exec (err, user) ->
      return res.badRequest(err)  if err
      res.ok(do user.getFollowings)


  addFollowing: (req, res) ->
    id     = req.param 'id'
    friend = req.param 'friend'

    User.findOne(id: id).exec (err, user) ->
      return res.badRequest(err)  if err

      User.findOne(friend).exec (err, friend) ->
        return res.badRequest(err)  if err

        unless user or friend
          errors = []
          generateError = (param, msg) -> errors.push param: param, msg: msg
          generateError('user', translate.get("Model.NotFound")) unless user
          generateError('friend', translate.get("Model.NotFound")) unless friend
          return res.notFound(errorify.serialize(errors))

        user.following.add friend
        friend.followers.add user

        user.save()
        friend.save()
        # user.addFollowing friend
        # friend.addFollower user
        res.ok(user)


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
      return res.badRequest(err) if err
      req.login user, (err) ->
        return res.badRequest(err) if err
        User.findOne(user.id).populateAll().exec (err, user) ->
          return res.badRequest(err) if err
          res.ok(user)
