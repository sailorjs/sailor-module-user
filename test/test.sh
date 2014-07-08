#!/bin/bash

function run_test {
  mocha -b "$@"
};

run_test \
test/create.test.js \
# test/destroy.test.js

# rm -rf testApp/
