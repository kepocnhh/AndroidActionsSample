#!/bin/bash

echo "Project prepare..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require BUILD_VARIANT KEYSTORE KEYSTORE_PASSWORD KEYSTORE_FINGERPRINT

RESOURCES=repository/app/src/$BUILD_VARIANT/resources
echo "$KEYSTORE" | base64 -d > $RESOURCES/key.pkcs12 \
 || . $SCRIPTS/util/throw 11 "Keystore error!"

ESCAPED=${KEYSTORE_PASSWORD//"\\"/"\\\\"}
echo "password=$ESCAPED" > $RESOURCES/properties \
 || . $SCRIPTS/util/throw 12 "Keystore password error!"

ACTUAL_FINGERPRINT="$(openssl pkcs12 -in $RESOURCES/key.pkcs12 -nokeys -passin pass:"$KEYSTORE_PASSWORD" \
 | openssl x509 -noout -fingerprint -sha256)" \
 || . $SCRIPTS/util/throw 13 "Actual fingerprint error!"

test "$ACTUAL_FINGERPRINT" != "SHA256 Fingerprint=${KEYSTORE_FINGERPRINT}" \
 && . $SCRIPTS/util/throw 14 "Expected fingerprint error!"

gradle -p repository app:compile${BUILD_VARIANT}Sources \
 || . $SCRIPTS/util/throw 15 "Gradle compile error!"

exit 0
