#!/bin/bash
set -eou pipefail

# First parameter to script determines the variant (e.g. delay0 or delay1)
DIRECTORY="$1"

# Use a wild-card to specifiy that every file with this pattern represents a testcase file
TESTCASES="test/hex/*.hex.txt"

# Loop over every file matching the TESTCASES pattern
for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .hex.txt)
    # Dispatch to the main test-case script
    ./test/run_one_testcase.sh ${DIRECTORY} ${TESTNAME}
done