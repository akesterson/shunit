#!/bin/bash

JUNIT_FAILURES=0
JUNIT_ERRORS=0
JUNIT_TESTS=0
JUNIT_TIMERSTART=$(date "+%s")

function junit_header()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    junit_header()

    This function doesn't actually do anything, it's a stub. Because junit
    is XML, which has to be ordered a certain way, this function does nothing
    but initialize some counters. Your unit test output won't actually get
    printed until you call junit_footer, which calls junit_header_real.
EOF
	return 1
    fi
    JUNIT_FAILURES=0
    JUNIT_ERRORS=0
    JUNIT_TESTS=0
    JUNIT_TIMERSTART=$(date "+%s")
    > /tmp/$$.junit
}

function junit_header_real()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    junit_header_real(tests, errors, failures, elapsed[, encoding])

    Generate a junit header, to display one or more junit_testcase()s.
    tests : total number of tests.
    errors : total number of errors
    failures : total number of failed test cases
    elapsed : The total number of seconds elapsed during testing
    encoding : Defaults to UTF-8, you should probably not change this.
EOF
	return 1
    fi

    local tests errors failures elapsed encoding

    tests=$1
    errors=$2
    failures=$3
    elapsed=$4
    encoding=$5

    if [ "$encoding" == "" ]; then
	encoding="UTF-8"
    fi

    echo '<?xml version="1.0" encoding="'$encoding'"?>'
    echo '<testsuite failures="'$failures'" time="'$elapsed'" timestamp="'$(date)'" errors="'$failures'" tests="'$tests'">'
    echo '    <properties/>'
}

function junit_footer()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    junit_footer()

    Print a junit footer. This will also call junit_header_real.
EOF
	return 1
    fi
    ELAPSED=$(expr $(date "+%s") - $JUNIT_TIMERSTART)
    junit_header_real $JUNIT_TESTS $JUNIT_ERRORS $JUNIT_FAILURES $ELAPSED "UTF-8"
    cat /tmp/$$.junit
    rm -f /tmp/$$.junit
    echo '</testsuite>'
}

function junit_testcase()
{
    if [ "$1" == "--help" ]; then
	cat <<EOF
    junit_testcase(classname, testname, elapsed[, failtype, failmsg, cdata])

    Generate XML to describe a junit test case.

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
    JUNIT_TESTS=$(expr $JUNIT_TESTS + 1)
    echo '    <testcase classname="'$classname'" time="'$elapsed'" name="'$testname'">' >> /tmp/$$.junit
    if [ "$failtype" != "" ]; then
	JUNIT_ERRORS=$(expr $JUNIT_ERRORS + 1)
	JUNIT_FAILURES=$(expr $JUNIT_FAILURES + 1)
        echo '        <failure type="'$failtype'" message="'$failmsg'">' >> /tmp/$$.junit
        echo '            <![CDATA[' >> /tmp/$$.junit
	echo "${cdata}" >> /tmp/$$.junit
        echo '            ]]>' >> /tmp/$$.junit
        echo '        </failure>' >> /tmp/$$.junit
    fi
    echo '    </testcase>' >> /tmp/$$.junit
}
