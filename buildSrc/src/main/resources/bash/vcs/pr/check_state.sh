#!/bin/bash

echo "VCS pull request check state..."

SCRIPTS=repository/buildSrc/src/main/resources/bash

. $SCRIPTS/util/require VCS_DOMAIN REPOSITORY_OWNER REPOSITORY_NAME PR_NUMBER

if test $# -ne 1; then
 echo "Script needs for 1 argument but actual $#"; exit 11
fi

EXPECTED_STATE="$1"

CODE=0
CODE=$(curl -w %{http_code} -o assemble/vcs/pr${PR_NUMBER}.json \
 "$VCS_DOMAIN/repos/$REPOSITORY_OWNER/$REPOSITORY_NAME/pulls/$PR_NUMBER")
if test $CODE -ne 200; then
 echo "Get pull request #$PR_NUMBER error!"
 echo "Request error with response code $CODE!"
 exit 21
fi

ACTUAL_STATE=$($SCRIPTS/util/jqx -sfs assemble/vcs/pr${PR_NUMBER}.json .state) \
 || . $SCRIPTS/util/throw $? "$(cat /tmp/jqx.o)"

. $SCRIPTS/util/assert -eq EXPECTED_STATE ACTUAL_STATE

exit 0
