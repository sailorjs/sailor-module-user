
var path = 'http://localhost:1342';

var paths = {
  root    : path,
  local: {
    create  : path + "/en/user/create/local",
    login   : path + "/en/user/login/local",
    logout  : path + "/en/user/logout",
    find    : path + "/en/user/find",
  }
};

module.exports = paths;
