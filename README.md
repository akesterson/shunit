The shunit script
======

shunit requires cmdarg. Install it first: https://github.com/akesterson/cmdarg

shunit is a bash script for running tests scripts that are written with the shunit library. To use it, first install it:

    make install
    
... If you want to install it somewhere other than / (not recommended), you can use:

    make PREFIX=/some/other/path install
    
... and it will install to /some/other/path/usr/...

... then run it with the name of a single bash test script or a whole directory of scripts:

    shunit -t test_script.sh
    shunit -t test_directory/

... The default output format is junit. You can select tunit with the '-f' flag:

    shunit -t test_script.sh -f tunit

Writing tests for the shunit script
======

* In your project, create a tests/ directory. This directory will contain a number of *.sh files. You can have any number of test functions in them, named "shunittest_***".
* Only functions in the *sh files named "shunittest_" will be executed.
* Doing anything other than "source" at the top level of your *sh test file is considered Very Bad Form (tm)
* We don't care what your shunittest_ functions do, except that they MUST:
 * Exit 0 to indicate that the test has succeeded, - OR -
 * Print something informative to stderr, and Exit 1 to indicate that the test failed

For developers: The shunit library
======

shunit is just a set of bash functions for producing unit test output from bash scripts. I wrote this library because I often found myself writing things in bash whose output I wanted to consume as discrete pass/fail tasks into Bamboo, so I wrote the junit functions. Then later on, I got sick and tired of (as a human) reading junit output, so I wrote the tunit functions, so my scripts could output tunit or junit depending on which flags I passed.

Complete documentation is inside the functions (each function has --help) in ./lib/*unit.sh. A pair of complete examples are in tests/*unit.sh.

For developers: example output
==============

    akesterson@akesterson-pc ~/source/upstream/git/shunit
    $ bash tests/tunit.sh
    [super::class] someTest .... [OK]
    [super::class] someOtherTest .... [FAILED]
	    generic failure : Yo dawg, I heard you like failures
	    This is some raw data, please read it

    ==== 2 TESTS in 0 SECONDS : 1 ERRORS, 1 FAILURES ====

    akesterson@akesterson-pc ~/source/upstream/git/shunit
    $ bash tests/junit.sh
    <?xml version="1.0" encoding="UTF-8"?>
    <testsuite failures="1" time="0" timestamp="Wed Dec 19 22:51:02 EST 2012" errors="1" tests="2">
	<properties/>
	<testcase classname="super::class" time="31337" name="someTest">
	</testcase>
	<testcase classname="super::class" time="31337" name="someOtherTest">
	    <failure type="generic failure" message="Yo dawg, I heard you like failures">
		<![CDATA[
    This is some raw data, please read it
		]]>
	    </failure>
	</testcase>
    </testsuite>

shunit vs shunit2
=================

This library should not be confused with shunit2 (http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html). They are completely unrelated! I didn't even know shunit2 existed until long after I made this.

shunit2 seems neat, but I prefer shunit's style. shunit2 looks like it's trying to be a java-ish unit testing library, and doesn't operate very much like bash. shunit is much simpler; you don't need to know any assert commands, special constants, or how to report failure. You do your tests however you want, report error on stderr, return non-zero to indicate failure. It doesn't get much simpler than that!

The only really useful thing I can see in shunit2 vs shunit, I will admit, is the ability to skip tests. shunit does not currently know how to skip tests, and that is because I didn't fully understand junit when I wrote it, so it does not report on skipped tests even if it did skip them! I will add some mechanism for this at some point.
