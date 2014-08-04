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

  # Make the view located at `views/homepage.ejs` (or `views/homepage.jade`, etc. depending on your
  # default view engine) your home page.
  #
  # (Alternatively, remove this and add an `index.html` file in your `assets` directory)

  # create
  "POST /:lang?/user/:strategy?"  : "UserController.callback"

  # find
  # "GET //user/:strategy?"  : "UserController.callback"
  # "GET /:lang?/user/"     : {blueprint: 'find'}
  # "GET /:lang?/user/:id"  : {blueprint: 'findOne'}



  # find
  #"POST /:lang?/user/:id?"  : {blueprint: 'find'}

  # destroy
  #"DEL /:lang/user/:id?" : {blueprint: 'destroy'}

  # update
  # "PUT /:lang/user/:identifier?"         : "UserController.update"

  # create/local
  # login/local
  # "POST /:lang/user/:action/:strategy" : "UserController.callback"





  # findOne
  # "get /user/:identifier" : "UserController.findOne"

  # find
  # "get /user/:identifier" : "UserController.findOne"

  # remove
  # "delete /user/:identifier": "UsernController.destroy"

  # logout
  # "get /user/logout": "UserController.logout"

  # find

# find
# findOne
# update

# If a request to a URL doesn't match any of the custom routes above,
# it is matched against Sails route blueprints.  See `config/blueprints.js`
# for configuration options and examples.
