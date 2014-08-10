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
  --timeout 50000 \
  --slow 300 \
  "$@"
}

## Main
welcome && run \
test/create.test.coffee \
test/find.test.coffee \
test/update.test.coffee \
test/login.test.coffee
# test/logout.test.coffee \
# test/destroy.test.coffee
