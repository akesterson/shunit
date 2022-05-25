#!/bin/bash

libdir=$(readlink -f $(dirname ${BASH_SOURCE[0]}))/../lib                                                                                                                 
source ${libdir}/cmdarg.sh

function validate_format
{
	echo $1 | grep -E "^junit$|^tunit$" >/dev/null 2>&1
	return $?
}

cmdarg_info author "Andrew Kesterson <andrew@aklabs.net>"
cmdarg_info header "A bash script for unit testing other bash scripts in JUNIT or human-friendly formats"
cmdarg_info copyright "(MIT License)"
cmdarg 'f:' 'format' 'Format to print results in. Valid options are: [junit, tunit]' 'junit' validate_format
cmdarg 't:' 'tests' 'Directory or single file to test.'

cmdarg_parse "$@"

FORMATTER=${cmdarg_cfg['format']}

set -e
source ${libdir}/${FORMATTER}.sh
set +e

${FORMATTER}_header

if [[ -d ${cmdarg_cfg[tests]} ]]; then
    FILES=${cmdarg_cfg[tests]}/*sh
elif [[ -e ${cmdarg_cfg[tests]} ]]; then
    FILES=${cmdarg_cfg[tests]}
fi

for file in $FILES;
do
    declare -A tests
    source $file
    for key in $(declare -F | grep 'shunittest_')
    do
	if [[ "$(type -t $key)" == "function" ]]; then
	    start=$(date "+%s")
	    ERR=$($key 2>&1)
	    ERRFLAG=$?
	    delta=$(($(date "+%s") - $start))
	    if [[ $ERRFLAG -eq 0 ]]; then
		${FORMATTER}_testcase "$file" "$key" "$delta"
	    else
		SHORTERR=$(echo "$ERR" | head -n 1)
		${FORMATTER}_testcase "$file" "$key" "$delta" "Exit ${ERRFLAG}" "$SHORTERR" "${ERR}"
	    fi
	fi
	unset -f $key
    done
    unset tests
done

${FORMATTER}_footer
