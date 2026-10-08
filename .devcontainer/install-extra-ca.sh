#!/bin/sh
set -eu

CA_SOURCE_DIR=/mnt/ca
CA_TARGET_DIR=/usr/local/share/ca-certificates

for cert in "$CA_SOURCE_DIR"/*.crt; do
    [ -f "$cert" ] || continue

    install -m 0644 \
        "$cert" \
        "$CA_TARGET_DIR/$(basename "$cert")"
done

update-ca-certificates
