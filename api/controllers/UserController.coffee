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

  relationStatus: (req, res) ->
    user     = req.param 'id'
    follower = req.param 'follower'

    User.findOne(user).populate('following').exec (err, user) ->
      return res.badRequest(err)  if err

      User.findOne(follower).populate('follower').exec (err, follower) ->
        return res.badRequest(err)  if err
        unless user and follower
          errors = []
          errorify.addError(errors, 'id', translate.get("Model.NotFound")) unless user
          errorify.addError(errors, 'follower', translate.get("Model.NotFound")) unless follower
          return res.notFound(errorify.serialize(errors))

        res.ok
          you: if user.isFollowing(follower.id) then translate.get("User.Is.Following") else translate.get("User.Isnt.Following")
          follower: if follower.isFollowing(user.id) then translate.get("User.Is.Follower") else translate.get("User.Isnt.Follower")

  getFollowingOrFollowers: (req, res) ->
    methodName = req.route.path.split('/')[3]
    user       = id : req.param 'id'

    User.findOne(user).populate(methodName).exec (err, user) ->
      return res.badRequest(err)  if err
      unless user
        errors = errorify.addError([], 'id', translate.get("Model.NotFound"))
        return res.notFound(errorify.serialize(errors))

      res.ok(if methodName is 'following' then user.getFollowing() else user.getFollowers())


  getOutboxOrInbox: (req, res) ->
    methodName = req.route.path.split('/')[3]
    user       = id: req.param 'id'

    try
      User.findOne(user).populate(methodName).exec (err, user) ->
        return res.badRequest(err)  if err
        unless user
          errors = errorify.addError([], 'id', translate.get("Model.NotFound"))
          return res.notFound(errorify.serialize(errors))
        res.ok(if methodName is 'inbox' then user.getInbox() else user.getOutbox())
    catch
      res.notSupported()

  addOrRemoveFollowing: (req, res) ->
    user     = req.param 'id'
    follower = req.param 'follower'

    User.findOne(user).populate('following').exec (err, user) ->
      return res.badRequest(err)  if err

      User.findOne(follower).populate('follower').exec (err, follower) ->
        return res.badRequest(err)  if err

        unless user and follower
          errors = []
          errorify.addError(errors, 'id', translate.get("Model.NotFound")) unless user
          errorify.addError(errors, 'follower', translate.get("Model.NotFound")) unless follower
          return res.notFound(errorify.serialize(errors))

        if req.route.method is 'post'
          user.addFollowing follower, (err, user) ->
            return res.negotiate(err)  if err
            follower.addFollower user, (err, follower) ->
              return res.negotiate(err)  if err
              res.ok(user)

        else if req.route.method is 'delete'
          user.removeFollowing follower.id, (err, user) ->
            return res.negotiate(err)  if err
            follower.removeFollower user.id, (err, follower) ->
              return res.negotiate(err)  if err
              res.ok(user)
        else
          res.badRequest()

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
    methodName = req.route.path.split('/')[3]
    passport.callback req, res, (err, user) ->
      return res.badRequest(err) if err
      req.login user, (err) ->
        return res.badRequest(err) if err
        User.findOne(user.id).populateAll().exec (err, user) ->
          return res.badRequest(err) if err
          res.ok(user)
