#!/bin/bash

echo "Workflow verify on failed start..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require VCS_PAT REPOSITORY_OWNER REPOSITORY_NAME GITHUB_RUN_NUMBER GITHUB_RUN_ID

GIT_COMMIT_SHA=$($SCRIPTS/util/jqx -sfs assemble/vcs/commit.json .sha) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
AUTHOR_NAME=$($SCRIPTS/util/jqx -sfs assemble/vcs/commit/author.json .name) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
AUTHOR_HTML_URL=$($SCRIPTS/util/jqx -sfs assemble/vcs/commit/author.json .html_url) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

VERIFY_RESULT=" - see the report:"
ENVIRONMENT=diagnostics/summary.json
TYPES=($(jq -Mcer "keys|.[]" $ENVIRONMENT))
SIZE=${#TYPES[*]}
if test $SIZE == 0; then
 echo "Diagnostics should have determined the cause of the failure!"; exit 1
fi
PAGES_URL="https://${REPOSITORY_OWNER}.github.io/$REPOSITORY_NAME"
REPORT_PATH=$GITHUB_RUN_NUMBER/$GITHUB_RUN_ID/diagnostics/report
for ((i=0; i<SIZE; i++)); do
 TYPE="${TYPES[i]}"
 RELATIVE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.path") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 TITLE=$($SCRIPTS/util/jqx -sfs $ENVIRONMENT ".${TYPE}.title") \
  || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"
 VERIFY_RESULT="${VERIFY_RESULT}
    $((i+1))) [$TITLE](${PAGES_URL}/build/$REPORT_PATH/$RELATIVE/index.html)"
done

REPOSITORY_URL=https://github.com/$REPOSITORY_OWNER/$REPOSITORY_NAME

MESSAGE="CI build [#$GITHUB_RUN_NUMBER]($REPOSITORY_URL/actions/runs/$GITHUB_RUN_ID) failed!

[$REPOSITORY_OWNER](https://github.com/$REPOSITORY_OWNER) / [$REPOSITORY_NAME]($REPOSITORY_URL)

 - source [${GIT_COMMIT_SHA::7}]($REPOSITORY_URL/commit/$GIT_COMMIT_SHA) by [$AUTHOR_NAME]($AUTHOR_HTML_URL)
$VERIFY_RESULT"

/bin/bash repository/buildSrc/src/main/resources/bash/notification/telegram/send_message.sh "$MESSAGE" || exit 31

exit 0
