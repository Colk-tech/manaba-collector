
#!/bin/sh
set -eu

SOURCE_DIR=/mnt/ca
TARGET_DIR=/usr/local/share/ca-certificates

found=0

for cert in "$SOURCE_DIR"/*.crt "$SOURCE_DIR"/*.pem; do
    [ -f "$cert" ] || continue
    found=1

    count=$(grep -c '^-----BEGIN CERTIFICATE-----' "$cert")

    if [ "$count" -ne 1 ]; then
        echo "Expected exactly one PEM certificate: $cert" >&2
        exit 1
    fi

    name=$(basename "$cert")
    name=${name%.*}

    install -m 0644 \
        "$cert" \
        "$TARGET_DIR/extra-$name.crt"

    echo "Installed CA certificate: $name"
done

if [ "$found" -eq 0 ]; then
    echo "No additional CA certificates found in $SOURCE_DIR"
fi

update-ca-certificates
