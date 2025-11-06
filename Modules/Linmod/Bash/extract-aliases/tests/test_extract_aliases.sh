#!/bin/bash

# Test for the presence of the script
if [[ ! -f "./src/extract_aliases.sh" ]]; then
    echo "Test failed: extract_aliases.sh not found."
    exit 1
fi

# Test for usage information
output=$(bash ./src/extract_aliases.sh -h 2>&1)
if [[ $output != *"Usage:"* ]]; then
    echo "Test failed: Usage information not displayed correctly."
    exit 1
fi

# Additional tests can be added here

echo "All tests passed."