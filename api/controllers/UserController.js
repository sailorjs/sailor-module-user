var validator = require('validator');

/**
 * Authentication Controller
 *
 * This is merely meant as an example of how your Authentication controller
 * should look. It currently includes the minimum amount of functionality for
 * the basics of Passport.js to work.
 */
 module.exports = {

  /**
   * Log out a user and return them to the homepage
   *
   * Passport exposes a logout() function on req (also aliased as logOut()) that
   * can be called from any route handler which needs to terminate a login
   * session. Invoking logout() will remove the req.user property and clear the
   * login session (if any).
   *
   * For more information on logging out users in Passport.js, check out:
   * http://passportjs.org/guide/logout/
   *
   * @param {Object} req
   * @param {Object} res
   */
  logout: function (req, res) {
    req.logout();
    res.ok();
  },

  /**
   * Render the registration page
   *
   * @param {Object} req
   * @param {Object} res
   */
  register: function (req, res) {
    res.view({
      errors: req.flash('error')
    });
  },


  /**
   * Localize and delete a user from the system.
   * Is necessary the email or the username to proceed it.
   * @param  {[type]} req [description]
   * @param  {[type]} res [description]
   * @return {[type]} staths [description]
   */
  destroy: function(req, res){
    var identifier = req.param('id'),
        isEmail = validator.isEmail(identifier),
        user       = {};

    if (isEmail)
      user.email = identifier;
    else
      user.username = identifier;

    User.findOne(user, function (err, user) {
      if (err) return res.negotiate(err);

      // TODO: Cambiar por sailor-stringfile
      // sails.__('Error.Passport.User.NotFound'), user
      if (!user) return res.badRequest("User not found");

      User.destroy(user.id, function (err) {
        if (err) return res.negotiate(err);
        return res.ok(user);
      });
    });
  },

  /**
   * Create a third-party authentication endpoint
   *
   * @param {Object} req
   * @param {Object} res
   */
  provider: function (req, res) {
    passport.endpoint(req, res);
  },

  /**
   * Create a authentication callback endpoint
   *
   * This endpoint handles everything related to creating and verifying Pass-
   * ports and users, both locally and from third-aprty providers.
   *
   * Passport exposes a login() function on req (also aliased as logIn()) that
   * can be used to establish a login session. When the login operation
   * completes, user will be assigned to req.user.
   *
   * For more information on logging in users in Passport.js, check out:
   * http://passportjs.org/guide/login/
   *
   * @param {Object} req
   * @param {Object} res
   */
  callback: function (req, res) {
    passport.callback(req, res, function (err, user) {

      if (err){
        return res.badRequest(err);
      }

      req.login(user, function (err) {
        // If an error was thrown, redirect the user to the login which should
        // take care of rendering the error messages.
        if (err) {
          res.badRequest(err);
          // res.redirect(req.param('action') === 'register' ? '/register' : '/login');
        }
        // Upon successful login, send the user to the homepage were req.user
        // will available.
        else {
          res.ok();
        }
      });
    });
  }
};
