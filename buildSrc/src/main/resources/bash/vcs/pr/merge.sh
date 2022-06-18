#!/bin/bash

echo "VCS pull request merge..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require PR_NUMBER

WORKER_NAME=$($SCRIPTS/util/jqx -sfs assemble/vcs/worker.json .name) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
WORKER_VCS_EMAIL=$($SCRIPTS/util/jqx -sfs assemble/vcs/worker.json .vcs_email) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
GIT_BRANCH_DST=$($SCRIPTS/util/jqx -sfs assemble/vcs/pr${PR_NUMBER}.json .base.ref) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
GIT_COMMIT_SRC=$($SCRIPTS/util/jqx -sfs assemble/vcs/pr${PR_NUMBER}.json .head.sha) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

REPOSITORY=repository
. $SCRIPTS/util/assert -d $REPOSITORY

git -C $REPOSITORY config user.name "$WORKER_NAME" \
 && git -C $REPOSITORY config user.email "$WORKER_VCS_EMAIL" \
 || . $SCRIPTS/util/throw 41 "Git config error!"

git -C $REPOSITORY fetch origin $GIT_BRANCH_DST \
 || . $SCRIPTS/util/throw 42 "Git fetch \"$GIT_BRANCH_DST\" error!"

git -C $REPOSITORY checkout $GIT_BRANCH_DST \
 || . $SCRIPTS/util/throw 43 "Git checkout to \"$GIT_BRANCH_DST\" error!"

git -C $REPOSITORY merge --no-ff --no-commit $GIT_COMMIT_SRC \
 || . $SCRIPTS/util/throw 44 "Git merge ${GIT_COMMIT_SRC::7} -> \"$GIT_BRANCH_DST\" error!"

exit 0
