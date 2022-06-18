#!/bin/bash

echo "Workflow pull request unstable VCS tag test..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

REQUIRE_FILLED_STRING="select((.!=null)and(type==\"string\")and(.!=\"\"))"

VERSION_NAME=$($SCRIPTS/util/jqx -sfs assemble/project/common.json .version.name) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
VERSION_CODE=$($SCRIPTS/util/jqx -si assemble/project/common.json .version.code) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
TAG="${VERSION_NAME}-${VERSION_CODE}-UNSTABLE"

/bin/bash $SCRIPTS/vcs/tag/test.sh "$TAG" \
 || /bin/bash $SCRIPTS/workflow/pr/unstable/vcs/tag/test/on_failed.sh; exit 11

exit 0
