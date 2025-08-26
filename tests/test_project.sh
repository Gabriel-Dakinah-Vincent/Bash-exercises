#!/bin/bash

# Test Scriptman
if [[ ! -f "Scriptman" ]]; then
    echo "Test failed: Scriptman not found."
    exit 1
fi
bash Scriptman -h > /dev/null 2>&1 || { echo "Test failed: Scriptman help not working."; exit 1; }

echo "Scriptman basic test passed."

# Test extract_aliases.sh
if [[ ! -f "extract-aliases/src/extract_aliases.sh" ]]; then
    echo "Test failed: extract_aliases.sh not found."
    exit 1
fi
bash extract-aliases/src/extract_aliases.sh -h > /dev/null 2>&1 || { echo "Test failed: extract_aliases.sh help not working."; exit 1; }

echo "extract_aliases.sh basic test passed."

echo "All root-level tests passed."
