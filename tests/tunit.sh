#!/bin/bash

TESTDIR=$(dirname ${BASH_SOURCE})
. $TESTDIR/../lib/tunit.sh

tunit_header
tunit_testcase "super::class" "someTest" 31337
tunit_testcase "super::class" "someOtherTest" 31337 "generic failure" "Yo dawg, I heard you like failures" "This is some raw data, please read it"
tunit_footer

