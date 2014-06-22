var sys = require('sys');
var exec = require('child_process').exec;
var fs = require('fs');
var package = require('../package.json');
var sh = require('execSync');
var sailsrc = require('multiline')(function() {
  /*
{
  "generators": {
    "modules": {}
  },
  "plugins": [
    "%s"
  ]
}
*/
});
sailsrc = require('util').format(sailsrc, package.name);

var write_file = function(file, txt) {
  fs.writeFileSync(file, txt);
};

test = module.exports = {

  remove: function() {
    sh.run('cd .. && rm -rf testApp/');
  },

  create: function() {
    sh.run('cd .. && sails new testApp > /dev/null');
    sh.run('cd .. && rm testApp/node_modules/sails');
    sh.run('ln -s ../../node_modules/sails/ ../testApp/node_modules/sails');
    sh.run('ln -s ../../../' + package.name + '/ ../testApp/node_modules/' + package.name);
    write_file('../testApp/.sailsrc', sailsrc);
  },

  start: function() {
    sh.run('cd ../testApp && ./node_modules/sails/bin/sails.js lift');
  },

  stop: function(){
    sh.run("kill $(ps aux | grep '[s]ails' | awk '{print $2}')");
  }
};

test.remove();
test.create();
test.start();
