module.exports = (sails) ->
  initialize: (cb) ->
    sails.services.passport.loadStrategies()
    cb()
