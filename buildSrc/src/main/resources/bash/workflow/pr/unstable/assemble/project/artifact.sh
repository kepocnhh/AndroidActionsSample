#!/bin/bash

echo "Workflow pull request unstable assemble project artifact..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require REPOSITORY_NAME BUILD_VARIANT

REPOSITORY=repository
. $SCRIPTS/util/assert -d $REPOSITORY

VERSION_NAME=$($SCRIPTS/util/jqx -sfs assemble/project/common.json .version.name) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
VERSION_CODE=$($SCRIPTS/util/jqx -si assemble/project/common.json .version.code) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

ARTIFACT="${REPOSITORY_NAME}-${VERSION_NAME}-${VERSION_CODE}-${BUILD_VARIANT}.apk"

gradle -p "$REPOSITORY" app:assemble${BUILD_VARIANT^} \
 || . $SCRIPTS/util/throw 12 "Assemble \"$ARTIFACT\" error!"

RELATIVE="$REPOSITORY/app/build/outputs/apk/${BUILD_VARIANT}"
. $SCRIPTS/util/assert -f "$(pwd)/$RELATIVE/$ARTIFACT"

rm assemble/project/artifact/$ARTIFACT
mkdir -p assemble/project/artifact
mv $RELATIVE/$ARTIFACT assemble/project/artifact/$ARTIFACT || exit 1 # todo

exit 0
