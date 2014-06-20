module.exports.bootstrap = function(cb) {

  sails.services.passport.loadStrategies();
  // It's very important to trigger this callack method when you are finished
  // with the bootstrap!  (otherwise your server will never lift, since it's waiting on the bootstrap)
  cb();
};