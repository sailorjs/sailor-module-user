#!/bin/bash -x

welcome() {
echo "   _____ _____ _____ _____ _____ _   _ _____ "
echo "  |_   _|  ___/  ___|_   _|_   _| \ | |  __ \\"
echo "    | | | |__ \ \`--.  | |   | | |  \| | |  \/"
echo "    | | |  __| \`--. \ | |   | | | . \` | | __ "
echo "    | | | |___/\__/ / | |  _| |_| |\  | |_\ \\"
echo "    \_/ \____/\____/  \_/  \___/\_| \_/\____/"
}

run() {
  mocha \
  -b \
  --compilers coffee:coffee-script/register \
  --require should \
  --reporter spec \
  --timeout 80000 \
  --slow 300 \
  "$@"
}

## Main
welcome && run \
test/init.test.coffee \
test/create.test.coffee \
test/login.test.coffee \
test/find.test.coffee \
test/update.test.coffee \
test/relations.test.coffee \
test/destroy.test.coffee
