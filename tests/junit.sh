#!/bin/bash

TESTDIR=$(dirname ${BASH_SOURCE})
. $TESTDIR/../lib/junit.sh

junit_header
junit_testcase "super::class" "someTest" 31337
junit_testcase "super::class" "someOtherTest" 31337 "generic failure" "Yo dawg, I heard you like failures" "This is some raw data, please read it"
junit_footer

