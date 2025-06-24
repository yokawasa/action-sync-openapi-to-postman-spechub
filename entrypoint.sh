#!/usr/bin/env bash
set -x

POSTMAN_API_KEY=$1
POSTMAN_SPEC_ID=$2
OPENAPI_FILE_PATH=$3
OPENAPI_FORMAT=$4

if [ -z "${POSTMAN_API_KEY}" ]; then
  >&2 echo "Set the POSTMAN_API_KEY input variable."
  exit 1
fi
if [ -z "${POSTMAN_SPEC_ID}" ]; then
  >&2 echo "Set the POSTMAN_SPEC_ID input variable."
  exit 1
fi
# Checking if OPENAPI_FILE_PATH is NOT set or if the file does not exist
if [ -z "${OPENAPI_FILE_PATH}" ] || [ ! -f "${OPENAPI_FILE_PATH}" ]; then
  >&2 echo "Set the OPENAPI_FILE_PATH input variable to a valid file path."
  exit 1
fi
# Checking if OPENAPI_FORMAT is NOT set or if it is neither "json" or "yaml"
if [ -z "${OPENAPI_FORMAT}" ] || ([ "${OPENAPI_FORMAT}" != "json" ] && [ "${OPENAPI_FORMAT}" != "yaml" ]); then
  >&2 echo "Set the OPENAPI_FORMAT input variable to either json or yaml."
  exit 1
fi

main() {
  local openapi_content=$(cat "${OPENAPI_FILE_PATH}")

  curl --location --globoff \
  --request PATCH "https://api.getpostman.com/specs/${POSTMAN_SPEC_ID}/files/index.${OPENAPI_FORMAT}" \
  --header "Content-Type: application/json" \
  --header "X-API-Key: ${POSTMAN_API_KEY}" \
  --data "{
    \"content\": \"${openapi_content}\"
  }"
}

main "$@"
