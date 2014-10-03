path = "http://localhost:1337/"

paths =
  # CRUD
  create    : path + "user"
  update    : path + "user"
  find      : path + "user"
  destroy   : path + "user"
  # CUSTOM
  session   : path + "user/session"
  login     : path + "user/login"
  logout    : path + "user/logout"
  following : path + "user/following"
  followers : path + "user/followers"
  status    : path + "user/following/status"

## -- Exports -------------------------------------------------------------

module.exports = paths
