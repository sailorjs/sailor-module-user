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
  follower  : path + "user/follower"
  status    : path + "user/following/status"

## -- Exports -------------------------------------------------------------

module.exports = paths

# http://localhost:1337/user/following/1
