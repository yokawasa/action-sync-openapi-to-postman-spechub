#!/usr/bin/env bash

# Test script for entrypoint.sh

# Path to the script being tested
TEST_DIR="$(cd "$(dirname "$0")"; pwd)"
SCRIPT_PATH="${TEST_DIR}/../entrypoint.sh"

# Helper function to run a test case
run_test() {
  local description="$1"
  local command="$2"
  local expected_exit_code="$3"

  echo "Running test: $description"
  echo "Command: $command"
  eval "$command"
  local exit_code=$?

  if [ "$exit_code" -eq "$expected_exit_code" ]; then
    echo "✅ Test passed"
  else
    echo "❌ Test failed (Expected exit code: $expected_exit_code, Got: $exit_code)"
  fi
  echo
}

# Test cases

# Test: Missing POSTMAN_API_KEY
run_test "Missing POSTMAN_API_KEY" \
  "$SCRIPT_PATH '' 'spec_id' 'openapi.yaml' 'json'" \
  1

# Test: Missing POSTMAN_SPEC_ID
run_test "Missing POSTMAN_SPEC_ID" \
  "$SCRIPT_PATH 'api_key' '' 'openapi.yaml' 'json'" \
  1

# Test: Missing OPENAPI_FILE_PATH
run_test "Missing OPENAPI_FILE_PATH" \
  "$SCRIPT_PATH 'api_key' 'spec_id' '' 'json'" \
  1

# Test: Invalid OPENAPI_FORMAT
run_test "Invalid OPENAPI_FORMAT" \
  "$SCRIPT_PATH 'api_key' 'spec_id' 'openapi.yaml' 'invalid_format'" \
  1

# Test: Valid inputs (mocking curl)
MOCK_FILE_PATH="./mock_openapi.yaml"
echo '{"mock": "data"}' > "$MOCK_FILE_PATH"
run_test "Valid inputs (mocking curl)" \
  "bash -c 'function curl() { echo \"Mock curl called\"; }; export -f curl; $SCRIPT_PATH api_key spec_id $MOCK_FILE_PATH yaml'" \
  0

# Cleanup
rm -f "$MOCK_FILE_PATH"
