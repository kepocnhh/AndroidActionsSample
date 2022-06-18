#!/bin/bash

echo "VCS pull request commit..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require GITHUB_RUN_NUMBER PR_NUMBER

GIT_COMMIT_SRC=$($SCRIPTS/util/jqx -sfs assemble/vcs/pr${PR_NUMBER}.json .head.sha) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
GIT_COMMIT_DST=$($SCRIPTS/util/jqx -sfs assemble/vcs/pr${PR_NUMBER}.json .base.sha) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

REPOSITORY=repository
. $SCRIPTS/util/assert -d $REPOSITORY

MESSAGE="Merge ${GIT_COMMIT_SRC::7} -> ${GIT_COMMIT_DST::7} by CI build #${GITHUB_RUN_NUMBER}."
git -C $REPOSITORY commit -m "$MESSAGE" \
 || . $SCRIPTS/util/throw 41 "Git commit error!"

exit 0
