var validator  = require('validator');
var stringfile = require('sailor-stringfile');

/**
 * Local Authentication Protocol
 *
 * The most widely used way for websites to authenticate users is via a username
 * and/or email as well as a password. This module provides functions both for
 * registering entirely new users, assigning passwords to already registered
 * users and validating login requesting.
 *
 * For more information on local authentication in Passport.js, check out:
 * http://passportjs.org/guide/username-password/
 */

/**
 * Register a new user
 *
 * This method creates a new user from a specified email, username and password
 * and assign the newly created user a local Passport.
 *
 * @param {Object}   req
 * @param {Object}   res
 * @param {Function} next
 */
exports.register = function (req, res, next) {

  var password = req.param('password'),
      username = req.param('username'),
      email    = req.param('email');

  // TODO: Use Waterline Error Factory
  if (!email){
    return next(stringfile.create({
      type    : 'error',
      message : 'User.Email.NotFound',
      lang    : req.locale
    }));
  }

  // TODO: Use Waterline Error Factory
  if (!email){
    return next(stringfile.create({
      type    : 'error',
      message : 'User.Password.NotFound',
      lang    : req.locale
    }));
  }

  var user = {
    email : email,
    username : username
  };

  User.create(user)
  .exec(function (err, user) {
    // TODO: Use Waterline Error Factory
    if (err) return next(err, user);

    Passport.create({
      protocol : 'local',
      password : password,
      user     : user.id
    })
    .exec(function (err, passport) {
      // TODO: How Websockets in Sails works?
      if (req._sails.hooks.pubsub) {
        if (req.isSocket) {
          User.subscribe(req, user);
          User.introduce(user);
        }
        User.publishCreate(user, !req.options.mirror && req);
      }
      // TODO: Use Waterline Error Factory
      next(err, user);
    });
  });
};

/**
 * Assign local Passport to user
 *
 * This function can be used to assign a local Passport to a user who doens't
 * have one already. This would be the case if the user registered using a
 * third-party service and therefore never set a password.
 *
 * @param {Object}   req
 * @param {Object}   res
 * @param {Function} next
 */
exports.connect = function (req, res, next) {

  var user     = req.user,
      password = req.param('password');

  Passport.findOne({
    protocol : 'local',
    user     : user.id
  }, function (err, passport) {

    if (err) return next(err);

    if (!passport) {
      Passport.create({
        protocol : 'local',
        password : password,
        user     : user.id
      }, function (err, passport) {
        console.log("Se queda aqui");
        next(err, user);
      });
    }
    else {
      next(sails.__('Error.Passport.Strategy.Already'), user);
    }
  });
};

/**
 * Validate a login request
 *
 * Looks up a user using the supplied identifier (email or username) and then
 * attempts to find a local Passport associated with the user. If a Passport is
 * found, its password is checked against the password supplied in the form.
 *
 * @param {Object}   req
 * @param {string}   identifier
 * @param {string}   password
 * @param {Function} next
 */
exports.login = function (req, identifier, password, next) {
  var isEmail = validator.isEmail(identifier),
      user   = {};

  if (isEmail)
    user.email = identifier;
  else
    user.username = identifier;

  User.findOne(user, function (err, user) {

    if (err) return next(err);

    // TODO: Cambiar por sailor-stringfile
    if (!user) return next(sails.__('Error.Passport.User.NotFound'), user);

    Passport.findOne({
      protocol : 'local',
      user     : user.id
    }, function (err, passport) {
      if (err) next(err);

      if (passport) {
        passport.validatePassword(password, function (err, res) {

          if (err) {
            return next(err);
          }

          if (!res) {
            var errMessage = sails.__('Error.Passport.Password.Wrong');
            return next(errMessage);
          } else {
            return next(null, user);
          }
        });
      }
      else {
        var errMessage = sails.__('Error.Passport.Password.NotSet');
        return next(errMessage);
      }
    });
  });
};
