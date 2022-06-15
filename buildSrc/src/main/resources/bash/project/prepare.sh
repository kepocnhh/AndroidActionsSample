#!/bin/bash

echo "Project prepare..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require BUILD_VARIANT KEYSTORE KEYSTORE_PASSWORD

echo "$KEYSTORE" | base64 -d > repository/app/src/$BUILD_VARIANT/resources/key.pkcs12 \
 || . $SCRIPTS/util/throw 11 "Keystore error!"

ESCAPED=${KEYSTORE_PASSWORD//"\\"/"\\\\"}
echo "password=$ESCAPED" > repository/app/src/$BUILD_VARIANT/resources/properties \
 || . $SCRIPTS/util/throw 12 "Keystore password error!"

gradle -p repository app:compile${BUILD_VARIANT}Sources \
 || . $SCRIPTS/util/throw 13 "Gradle compile error!"

exit 0
