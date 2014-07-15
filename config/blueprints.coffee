module.exports.blueprints =

  # Action routes,
  #
  # which automatically create routes for your custom controller actions.
  # For example, if you have a FooController.js file with a bar method,
  # then a /foo/bar route will automatically be created for you as
  # long as blueprint action routes are enabled. Unlike RESTful and
  # shortcut routes, action routes do not require that a controller
  # has a corresponding model file.
  actions: true

  # RESTful routes,
  #
  # where the path is always /:modelIdentity or /:modelIdentity/:id.
  # These routes use the HTTP "verb" to determine the action to take;
  # for example a POST request to /user will create a new user, and a DELETE
  # request to /user/123 will delete the user whose primary key is 123. In a
  # production environment, RESTful routes should generally be protected by
  # policies to avoid unauthorized access.
  rest: true


  # Shortcut routes,
  #
  # where the action to take is encoded in the path.
  # For example, the /user/create?name=joe shortcut creates a new user, while
  # /user/update/1?name=mike updates user #1. These routes only respond to
  # GET requests Shortcut routes are very handy for development, but generally
  # should be disabled in a production environment.
  shortcuts: true

  # An optional mount path for all blueprint routes on a controller, including `rest`,
  # `actions`, and `shortcuts`.  This allows you to take advantage of blueprint routing,
  # even if you need to namespace your API methods.
  #
  # * (NOTE: This only applies to blueprint autoroutes, not manual routes from `sails.config.routes`)
  #
  # For example, `prefix: '/api/v2'` would make the following REST blueprint routes
  # for a FooController:
  #
  # `GET /api/v2/foo/:id?`
  # `POST /api/v2/foo`
  # `PUT /api/v2/foo/:id`
  # `DELETE /api/v2/foo/:id`
  #
  # By default, no prefix is used.
  prefix: ""

  # Whether to pluralize controller names in blueprint routes.
  #
  # (NOTE: This only applies to blueprint autoroutes, not manual routes from `sails.config.routes`)
  #
  # For example, REST blueprints for `FooController` with `pluralize` enabled:
  # GET    /foos/:id?
  # POST   /foos
  # PUT    /foos/:id?
  # DELETE /foos/:id?
  pluralize: false
