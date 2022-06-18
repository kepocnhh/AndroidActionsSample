#!/bin/bash

echo "Workflow pull request unstable VCS tag test on failed..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

/bin/bash $SCRIPTS/vcs/pr/close.sh || exit 11 # todo

. $SCRIPTS/util/require REPOSITORY_OWNER REPOSITORY_NAME \
 GITHUB_RUN_NUMBER GITHUB_RUN_ID PR_NUMBER

VERSION_NAME=$($SCRIPTS/util/jqx -sfs assemble/project/common.json .version.name) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
VERSION_CODE=$($SCRIPTS/util/jqx -si assemble/project/common.json .version.code) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
TAG="${VERSION_NAME}-${VERSION_CODE}-UNSTABLE"

REPOSITORY_URL=https://github.com/$REPOSITORY_OWNER/$REPOSITORY_NAME

MESSAGE="Closed by CI build [#$GITHUB_RUN_NUMBER]($REPOSITORY_URL/actions/runs/$GITHUB_RUN_ID)
 - tag \`$TAG\` test  failed!"

/bin/bash $SCRIPTS/vcs/pr/comment.sh "$MESSAGE" || exit 31 # todo

GIT_COMMIT_SRC="$(jq -Mcer ".head.sha|$REQUIRE_FILLED_STRING" assemble/vcs/pr${PR_NUMBER}.json)" || exit 1 # todo
AUTHOR_NAME_SRC="$(jq -Mcer ".name|$REQUIRE_FILLED_STRING" assemble/vcs/commit/author.src.json)" || exit 1 # todo
AUTHOR_HTML_URL_SRC="$(jq -Mcer ".html_url|$REQUIRE_FILLED_STRING" assemble/vcs/commit/author.src.json)" || exit 1 # todo
GIT_COMMIT_DST="$(jq -Mcer ".base.sha|$REQUIRE_FILLED_STRING" assemble/vcs/pr${PR_NUMBER}.json)" || exit 1 # todo
AUTHOR_NAME_DST="$(jq -Mcer ".name|$REQUIRE_FILLED_STRING" assemble/vcs/commit/author.dst.json)" || exit 1 # todo
AUTHOR_HTML_URL_DST="$(jq -Mcer ".html_url|$REQUIRE_FILLED_STRING" assemble/vcs/commit/author.dst.json)" || exit 1 # todo
WORKER_NAME="$(jq -Mcer ".name|$REQUIRE_FILLED_STRING" assemble/vcs/worker.json)" || exit 1 # todo
WORKER_HTML_URL="$(jq -Mcer ".html_url|$REQUIRE_FILLED_STRING" assemble/vcs/worker.json)" || exit 1 # todo

MESSAGE="CI build [#$GITHUB_RUN_NUMBER]($REPOSITORY_URL/actions/runs/$GITHUB_RUN_ID) failed!

[$REPOSITORY_OWNER](https://github.com/$REPOSITORY_OWNER) / [$REPOSITORY_NAME]($REPOSITORY_URL)

The pull request [#$PR_NUMBER]($REPOSITORY_URL/pull/$PR_NUMBER)
 - source [${GIT_COMMIT_SRC::7}]($REPOSITORY_URL/commit/$GIT_COMMIT_SRC) by [$AUTHOR_NAME_SRC]($AUTHOR_HTML_URL_SRC)
 - destination [${GIT_COMMIT_DST::7}]($REPOSITORY_URL/commit/$GIT_COMMIT_DST) by [$AUTHOR_NAME_DST]($AUTHOR_HTML_URL_DST)
 - tag \`$TAG\` test failed!
 - closed by [$WORKER_NAME]($WORKER_HTML_URL)"

/bin/bash $SCRIPTS/notification/telegram/send_message.sh "$MESSAGE" || exit 32

exit 0
