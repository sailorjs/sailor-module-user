var passport, path, url;

path = require("path");

url = require("url");

passport = require("passport");


/*
Passport Service

A painless Passport.js service for your Sails app that is guaranteed to
Rock Your Socks™. It takes all the hassle out of setting up Passport.js by
encapsulating all the boring stuff in two functions:

passport.endpoint()
passport.callback()

The former sets up an endpoint (/auth/:provider) for redirecting a user to a
third-party provider for authentication, while the latter sets up a callback
endpoint (/auth/:provider/callback) for receiving the response from the
third-party provider. All you have to do is define in the configuration which
third-party providers you'd like to support. It's that easy!

Behind the scenes, the service stores all the data it needs within "Pass-
ports". These contain all the information required to associate a local user
with a profile from a third-party provider. This even holds true for the good
ol' password authentication scheme – the Authentication Service takes care of
encrypting passwords and storing them in Passports, allowing you to keep your
User model free of bloat.
 */

passport.protocols = require("./protocols");


/*
Connect a third-party profile to a local user

This is where most of the magic happens when a user is authenticating with a
third-party provider. What it does, is the following:

1. Given a provider and an identifier, find a mathcing Passport.
2. From here, the logic branches into two paths.

- A user is not currently logged in:
1. If a Passport wassn't found, create a new user as well as a new
Passport that will be assigned to the user.
2. If a Passport was found, get the user associated with the passport.

- A user is currently logged in:
1. If a Passport wasn't found, create a new Passport and associate it
with the already logged in user (ie. "Connect")
2. If a Passport was found, nothing needs to happen.

As you can see, this function handles both "authentication" and "authori-
zation" at the same time. This is due to the fact that we pass in
`passReqToCallback: true` when loading the strategies, allowing us to look
for an existing session in the request and taking action based on that.

For more information on auth(entication|rization) in Passport.js, check out:
http://passportjs.org/guide/authenticate/
http://passportjs.org/guide/authorize/

@param {Object}   req
@param {Object}   query
@param {Object}   profile
@param {Function} next
 */

passport.connect = function(req, query, profile, next) {
  var config, strategies, user;
  strategies = sails.config.passport;
  config = strategies[profile.provider];
  user = {};
  query.provider = req.param("provider");
  if (profile.hasOwnProperty("emails")) {
    user.email = profile.emails[0].value;
  }
  if (profile.hasOwnProperty("username")) {
    user.username = profile.username;
  }
  if (!user.username && !user.email) {
    return next(new Error("Neither a username nor email was available"));
  }
  Passport.findOne({
    provider: profile.provider,
    identifier: query.identifier.toString()
  }, function(err, passport) {
    if (err) {
      return next(err);
    }
    if (!req.user) {
      if (!passport) {
        User.create(user, function(err, user) {
          if (err) {
            if (err.code === "E_VALIDATION") {
              req.flash("error", (err.invalidAttributes.email ? "Error.Passport.Email.Exists" : "Error.Passport.User.Exists"));
            }
            return next(err);
          }
          query.user = user.id;
          Passport.create(query, function(err, passport) {
            if (err) {
              return next(err);
            }
            next(err, user);
          });
        });
      } else {
        if (query.hasOwnProperty("tokens") && query.tokens !== passport.tokens) {
          passport.tokens = query.tokens;
        }
        passport.save(function(err, passport) {
          if (err) {
            return next(err);
          }
          User.findOne(passport.user, next);
        });
      }
    } else {
      if (!passport) {
        query.user = req.user.id;
        Passport.create(query, function(err, passport) {
          if (err) {
            return next(err);
          }
          next(err, req.user);
        });
      } else {
        next(null, req.user);
      }
    }
  });
};


/*
Create an authentication endpoint

For more information on authentication in Passport.js, check out:
http://passportjs.org/guide/authenticate/

@param  {Object} req
@param  {Object} res
 */

passport.endpoint = function(req, res) {
  var options, provider, strategies;
  strategies = sails.config.passport;
  provider = req.param("provider");
  options = {};
  if (!strategies.hasOwnProperty(provider)) {
    return res.redirect("/login");
  }
  if (strategies[provider].hasOwnProperty("scope")) {
    options.scope = strategies[provider].scope;
  }
  return this.authenticate(provider, options)(req, res, req.next);
};


/*
Create an authentication callback endpoint

For more information on authentication in Passport.js, check out:
http://passportjs.org/guide/authenticate/

@param {Object}   req
@param {Object}   res
@param {Function} next
 */

passport.callback = function(req, res, next) {
  var action, provider;
  provider = req.param("provider", "local");
  action = req.param("action");

  // DEBUG
  sails.log.blank();
  sails.log("Passport Callback");
  sails.log("Action: " + action);
  sails.log("Provider: " + provider);
  sails.log.blank();
  if (provider === "local" && action !== undefined) {
    if (action === "register" && !req.user) {
      return this.protocols.local.register(req, res, next);
    } else if (action === "connect" && req.user) {
      return this.protocols.local.connect(req, res, next);
    } else {
      return next(new Error("Invalid action"));
    }
  } else {
    return this.authenticate(provider, next)(req, res, req.next);
  }
};


/*
Load all strategies defined in the Passport configuration

For example, we could add this to our config to use the GitHub strategy
with permission to access a users email address (even if it's marked as
private) as well as permission to add and update a user's Gists:

github: {
name: 'GitHub',
protocol: 'oauth2',
scope: [ 'user', 'gist' ]
options: {
clientID: 'CLIENT_ID',
clientSecret: 'CLIENT_SECRET'
}
}

For more information on the providers supported by Passport.js, check out:
http://passportjs.org/guide/providers/
 */

passport.loadStrategies = function() {
  var self, strategies;
  self = this;
  strategies = sails.config.passport;
  return Object.keys(strategies).forEach(function(key) {
    var Strategy, baseUrl, callback, options, protocol;
    options = {
      passReqToCallback: true
    };
    Strategy = void 0;
    if (key === "local") {
      _.extend(options, {
        usernameField: "identifier"
      });
      if (strategies.local) {
        Strategy = strategies[key].strategy;
        return self.use(new Strategy(options, self.protocols.local.login));
      }
    } else {
      protocol = strategies[key].protocol;
      callback = strategies[key].callback;
      if (!callback) {
        callback = path.join("auth", key, "callback");
      }
      Strategy = strategies[key].strategy;
      baseUrl = sails.getBaseurl();
      switch (protocol) {
        case "oauth":
        case "oauth2":
          options.callbackURL = url.resolve(baseUrl, callback);
          break;
        case "openid":
          options.returnURL = url.resolve(baseUrl, callback);
          options.realm = baseUrl;
          options.profile = true;
      }
      _.extend(options, strategies[key].options);
      return self.use(new Strategy(options, self.protocols[protocol]));
    }
  });
};

passport.serializeUser(function(user, next) {
  return next(null, user.id);
});

passport.deserializeUser(function(id, next) {
  return User.findOne(id, next);
});

module.exports = passport;
