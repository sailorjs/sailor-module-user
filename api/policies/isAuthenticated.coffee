###
isAuthenticated

@module      :: Policy
@description :: Simple policy to allow any authenticated user
Assumes that your login action in one of your controllers sets `req.session.authenticated = true;`
@docs        :: http://sailsjs.org/#!documentation/policies
###
module.exports = (req, res, next) ->

  # If `req.user` exists, that means the passport middleware was able to
  # inflate/hydrate/deserialize a valid user from the session.
  return next()  if req.user
  res.unauthorized()
