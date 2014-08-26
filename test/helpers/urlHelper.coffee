path = "http://localhost:1337"

paths =
  # CRUD
  create:  path + "/en/user"
  update:  path + "/en/user"
  find:    path + "/en/user"
  destroy: path + "/en/user"
  # CUSTOM
  session: path + "/en/user/session"
  login:   path + "/en/user/login"
  logout:  path + "/en/user/logout"



module.exports = paths
