###
Route Mappings
(sails.config.routes)

Your routes map URLs to views and controllers.

If Sails receives a URL that doesn't match any of the routes below,
it will check for matchtching files (images, scripts, stylesheets, etc.)
in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
might match an image file: `/assets/images/foo.jpg`

Finally, if those don't match either, the default 404 handler is triggered.
See `config/404.js` to adjust your app's 404 logic.

Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
CoffeeScript for the front-end.

For more information on routes, check out:
http://links.sailsjs.org/docs/config/routes
###
module.exports.routes =

  # relations
  'GET /user/:id/follower'             : 'UserController.getFollowingOrFollowers'
  'GET /user/:id/following'            : 'UserController.getFollowingOrFollowers'
  'GET /user/:id/following/status'     : 'UserController.relationStatus'
  'DELETE /user/:id/following'         : 'UserController.addOrRemoveFollowing'
  'POST /user/:id/following'           : 'UserController.addOrRemoveFollowing'

  # create
  'POST /user'                         : 'UserController.callback'

  # login (local)
  'POST /user/:action?'                : 'UserController.callback'

  # login (third party)
  # TODO

  # session
  'GET /user/session'                  : 'UserController.session'

  # logout
  'GET /user/logout'                   : 'UserController.logout'
