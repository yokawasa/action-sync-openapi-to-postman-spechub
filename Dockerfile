# Dockerfile for a minimal Alpine image with bash, curl, jq, and ca-certificates
FROM alpine:latest

LABEL maintainer="Yoichi Kawasaki <yokawasa@gmail.com>"
LABEL repository="https://github.com/yokawasa/action-sync-openapi-to-postman-spechub"

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    ca-certificates && \
    update-ca-certificates

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
