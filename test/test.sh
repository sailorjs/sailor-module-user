#!/bin/bash

function welcome {
echo "   _____  ___  _____ _     ___________ "
echo "  /  ___|/ _ \|_   _| |   |  _  | ___ \\"
echo "  \ \`--./ /_\ \ | | | |   | | | | |_/ /"
echo "   \`--. \  _  | | | | |   | | | |    / "
echo "  /\__/ / | | |_| |_| |___\ \_/ / |\ \ "
echo "  \____/\_| |_/\___/\_____/\___/\_| \_|"
echo "                                       "
echo "   _____ _____ _____ _____ _____ _   _ _____ "
echo "  |_   _|  ___/  ___|_   _|_   _| \ | |  __ \\"
echo "    | | | |__ \ \`--.  | |   | | |  \| | |  \/"
echo "    | | |  __| \`--. \ | |   | | | . \` | | __ "
echo "    | | | |___/\__/ / | |  _| |_| |\  | |_\ \\"
echo "    \_/ \____/\____/  \_/  \___/\_| \_/\____/"
echo "                                             "
}


function run_test {
  mocha -b "$@"
};

## Main
welcome
run_test \
test/create.test.js \
test/destroy.test.js

# rm -rf testApp/
