#!/bin/bash

# tunit is short for "text unit", which is something I completely made
# up. Every unit test is printed in the following format:
#
# [ TEST NAME ] ... [ OK | FAIL ]
#
# If COLOR=on, then the OK/FAIL bits are in RED or GREEN.

SHUNIT_FAILURES=0
SHUNIT_ERRORS=0
SHUNIT_TESTS=0
SHUNIT_TIMERSTART=$(date "+%s")

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
    tunit_header()

    Generate a tunit header, to display one or more tunit_testcase()s.
    Tunit doesn't have a header, so this function doesn't currently do anything.
EOF
	return 1
    fi
    SHUNIT_FAILURES=0
    SHUNIT_ERRORS=0
    SHUNIT_TESTS=0
    SHUNIT_TIMERSTART=$(date "+%s")
    return 0
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
    local errcolor failcolor elapsed
    elapsed=$(expr $(date "+%s") - $SHUNIT_TIMERSTART)
    errcolor="${COLOR_GREEN}"
    failcolor="${COLOR_GREEN}"

    if [ $SHUNIT_ERRORS -gt 0 ]; then
	errcolor="${COLOR_RED}"
    fi
    if [ $SHUNIT_FAILURES -gt 0 ]; then
	failcolor="${COLOR_RED}"
    fi
    echo
    echo "==== $SHUNIT_TESTS TESTS in $elapsed SECONDS : ${errcolor}$SHUNIT_ERRORS ERRORS${COLOR_NORMAL}, ${errcolor}$SHUNIT_FAILURES FAILURES${COLOR_NORMAL} ===="

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

    SHUNIT_TESTS=$(expr $SHUNIT_TESTS + 1)
    printf "[$classname] $testname .... "
    if [ "$failtype" != "" ]; then
	SHUNIT_ERRORS=$(expr $SHUNIT_ERRORS + 1)
	SHUNIT_FAILURES=$(expr $SHUNIT_FAILURES + 1)
	echo "${COLOR_RED}[FAILED]"
	echo "        $failtype : $failmsg"
	echo "$cdata" | sed s/"^"/"        "/g
	echo "${COLOR_NORMAL}"
    else
	echo "${COLOR_GREEN}[OK]${COLOR_NORMAL}"
    fi
}
