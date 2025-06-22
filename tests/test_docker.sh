#!/usr/bin/env bash

TEST_DIR="$(cd "$(dirname "$0")"; pwd)"
DOCKERFILE_DIR="${TEST_DIR}/.."
IMAGE_NAME="sync-openapi-to-postman-spechub"

# Build the Docker image
docker build -t "$IMAGE_NAME" "$DOCKERFILE_DIR"
if [ $? -ne 0 ]; then
  echo "Failed to build Docker image."
  exit 1
fi

# Run the Docker container with test cases
# docker run --rm <IMAGE_NAME> <POSTMAN_API_KEY> <POSTMAN_SPEC_ID> <OPENAPI_FILE_PATH> <OPENAPI_FORMAT>

docker run --rm \
  "$IMAGE_NAME" \
  "test_api_key" "test_spec_id" "dummy_openapi.yaml" "yaml"
if [ $? -ne 0 ]; then
  echo "Failed as expected"
  exit 0
fi
