#!/bin/bash

# tunit is short for "text unit", which is something I completely made
# up. Every unit test is printed in the following format:
#
# [ TEST NAME ] ... [ OK | FAIL ]
#
# If COLOR=on, then the OK/FAIL bits are in RED or GREEN.

COLOR=${COLOR:-on}

if [ "$COLOR" == "on" ]; then
	COLOR_GREEN=$(echo -e '\033[0;32;40m');
	COLOR_RED=$(echo -e '\033[0;31;40m');
	COLOR_NORMAL=$(echo -e '\033[0m');
else
	COLOR_GREEN=""
	COLOR_RED=""
	COLOR_NORMAL=""
fi


function tunit_header()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    tunit_header(tests, errors, failures, elapsed)

    Generate a tunit header, to display one or more tunit_testcase()s.
    tests : total number of tests.
    errors : total number of errors
    failures : total number of failed test cases
    elapsed : The total number of seconds elapsed during testing
EOF
	return 1
    fi

    local tests errors failures elapsed encoding
    local errcolor failcolor

    tests=${1:-0}
    errors=${2:-0}
    failures=${3:-0}
    elapsed=${4:-0}

    errcolor="${COLOR_GREEN}"
    failcolor="${COLOR_GREEN}"

    if [ $errors -gt 0 ]; then
	errcolor="${COLOR_RED}"
    fi
    if [ $failures -gt 0 ]; then
	failcolor="${COLOR_RED}"
    fi
    echo
    echo "==== $tests TESTS in $elapsed SECONDS : ${errcolor}$errors ERRORS${COLOR_NORMAL}, ${errcolor}$failures FAILURES${COLOR_NORMAL} ===="
}

function tunit_footer()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    tunit_footer()

    Print a tunit footer.
EOF
	return 1
    fi
    return 0
}

function tunit_testcase()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    tunit_testcase(classname, testname, elapsed[, failtype, failmsg, cdata])

    Generate text to describe a tunit test case.
    classname : the name of the class containing the test
    testname : the name of the test in this class
    elapsed : Number of seconds elapsed during testing
    failtype : A one-word description of the failure type (generally an exception name or code)
    failmsg : A brief message (<32 chars) describing the failure
    cdata : More detailed information about the failure.
EOF

	return 1
    fi
    local classname testname elapsed failtype failmsg cdata

    classname="$1"
    testname="$2"
    elapsed=$3
    failtype="$4"
    failmsg="$5"
    cdata="$6"

    printf "[$classname] $testname .... "
    if [ "$failtype" != "" ]; then
	echo "${COLOR_RED}[FAILED]"
	echo "        $failtype : $failmsg"
	echo "$cdata" | sed s/"^"/"        "/g
	echo "${COLOR_NORMAL}"
    else
	echo "${COLOR_GREEN}[OK]${COLOR_NORMAL}"
    fi
}
