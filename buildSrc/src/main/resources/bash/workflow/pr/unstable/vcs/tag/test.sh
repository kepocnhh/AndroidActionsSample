#!/bin/bash

echo "Workflow pull request unstable VCS tag test..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

VERSION_NAME=$($SCRIPTS/util/jqx -sfs assemble/project/common.json .version.name) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
VERSION_CODE=$($SCRIPTS/util/jqx -si assemble/project/common.json .version.code) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
TAG="${VERSION_NAME}-${VERSION_CODE}-UNSTABLE"

CODE=0
/bin/bash $SCRIPTS/vcs/tag/test.sh "$TAG"; CODE=$?
if test $CODE -ne 0; then
 /bin/bash $SCRIPTS/workflow/pr/unstable/vcs/tag/test/on_failed.sh; exit 11
fi

exit 0
