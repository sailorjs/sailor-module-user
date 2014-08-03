path = "http://localhost:1342"

paths =
  # CRUD
  create:  path + "/en/user"
  update:  path + "/en/user"
  find:    path + "/en/user"
  destroy: path + "/en/user"
  # CUSTOM
  login:   path + "/en/user/login/local"
  logout:  path + "/en/user/logout"


module.exports = paths
