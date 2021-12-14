#!/bin/bash
set -eou pipefail

DIRECTORY="$1"
TESTCASE="$2"

iverilog -g 2012 \
   -s mips_cpu_bus_tb \
   -P mips_cpu_bus_tb.RAM_INIT_FILE=\"test/hex/${TESTCASE}.hex.txt\" \
   -o test/simulator/${TESTCASE} \
   ${DIRECTORY}/mips_cpu_*.v

set +e
test/simulator/${TESTCASE} > test/output/${TESTCASE}.stdout
# Capture the exit code of the simulator in a variable
RESULT=$?
set -e

if [[ "${RESULT}" -ne 0 ]] ; then
   echo   ${TESTCASE}  $'\t' Fail
   exit
fi

PATTERN="register_v0 = "
NOTHING=""
# Use "grep" to look only for lines containing PATTERN
set +e
grep "${PATTERN}" test/output/${TESTCASE}.stdout > test/output/${TESTCASE}.out-lines
set -e
# Use "sed" to replace "CPU : OUT   :" with nothing
set +e
sed -e "s/${PATTERN}/${NOTHING}/g" test/output/${TESTCASE}.out-lines > test/output/${TESTCASE}.out
set -e

set +e
diff -w test/reference/${TESTCASE}.out test/output/${TESTCASE}.out
RESULT=$?
set -e

FN=$(echo ${TESTCASE}| cut -d'_' -f 1)

if [[ "${RESULT}" -ne 0 ]] ; then
   echo   ${TESTCASE}  $'\t' ${FN} $'\t' Fail
else
   echo   ${TESTCASE}  $'\t' ${FN} $'\t' Pass
fi